#!/bin/bash
#
# This script should be run via curl:
#   curl -fsSL https://codeberg.org/tuck/dotfiles/raw/branch/main/install.sh | sh"
#
# As an alternative, you can first download the install script and run it afterwards:
#   wget https://codeberg.org/tuck/dotfiles/raw/branch/main/install.sh
#   sh install.sh
#
# You can tweak the install behavior by setting variables when running the script. For
# example, to change the path of the dotfiles to ~/.dotfiles:
#   DOTS=~/.dotfiles sh install.sh
#
# Respects the following environment variables:
#   DOTS        - path to the dots repository folder (default: $HOME/.dots)
#   DOTS_NAME   - name of the dots command (default: dots)
#   REPO        - name of the Codeberg repo to install from (default: dantuck/dotfiles)
#   REMOTE      - full remote URL of the git repo to install (default: Codeberg via HTTPS)
#   BRANCH      - branch to check out immediately after install (default: main)
#
set -e

# Default settings
DOTS=${DOTS:-$HOME/.dots}
DOTS_NAME=${DOTS_NAME:-dots}
REPO=${REPO:-tuck/dotfiles}
REMOTE=${REMOTE:-https://codeberg.org/${REPO}.git}
BRANCH=${BRANCH:-main}
INSTALL_FOR_SHELL=${1:-fish}

# The [ -t 1 ] check only works when the function is not called from
# a subshell (like in `$(...)` or `(...)`, so this hack redefines the
# function at the top level to always return false when stdout is not
# a tty.
if [ -t 1 ]; then
  is_tty() {
    true
  }
else
  is_tty() {
    false
  }
fi

# Only use colors if connected to a terminal
if is_tty; then
  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  RESET=""
fi

info_header() {
  local string="$1"
  local color="${2:-BLUE}"
  local desired_length=60

  local num_dashes=$((desired_length - ${#string}))
  local dashes=$(printf '%*s' "$num_dashes" | tr ' ' '-')

  echo
  case $color in
    yellow|YELLOW*)
      echo "${YELLOW}---- $string $dashes${RESET}" ;;  
    *) 
      echo "${BLUE}---- $string $dashes${RESET}" ;;
  esac
}

fmt_error() {
  printf '%sError: %s%s\n' "$BOLD$RED" "$*" "$RESET" >&2
}

# shellcheck disable=SC2016 # backtick in single-quote
fmt_code() {
  is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

confirm() {
  local question=$1
  local default=${2:-Y}

  read -r -p "$question [Y/n] " response
  response=${response,,}    # convert input to lowercase

  if [[ $response =~ ^(yes|y| ) || -z $response ]]; then
    return 0    # Confirmed
  else
    return 1    # Cancelled
  fi
}

setup_dots() {
  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  info_header "Installing DOTS"
  cat << EOF
'dots' is a utility command to help manage your dotfiles,
keeping them updated and synced with any given git remotes.
EOF

  # echo "${BLUE}Cloning dots...${RESET}"

  _install_git?
  _clone
  
  echo
}

_clone() {
  echo
  git clone -c core.eol=lf -c core.autocrlf=false \
    -c fsck.zeroPaddedFilemode=ignore \
    -c fetch.fsck.zeroPaddedFilemode=ignore \
    -c receive.fsck.zeroPaddedFilemode=ignore \
    -c dots.remote=origin \
    -c dots.branch="$BRANCH" \
    --depth=1 --branch "$BRANCH" "$REMOTE" "$DOTS" || {
    fmt_error "git clone of dots repo failed"
    exit 1
  }
}

_reload() {
  exec "$SHELL" -l
}

_install_git?() {
  if ! command_exists? git; then
    info_header "Install git?"
    cat << EOF
${YELLOW}Git is not installed.${RESET}

We need 'git' so that your git remote can be pulled and
setup dotfiles with sprinkles of magic!

You can install it with your own method or temporarily use
nixpkgs. With this method, git will be installed via nix
and then removed after completion. Git is removed just in
case your dotfiles manage the git installation.

EOF

    if _install_nix?; then
      nix-env -iA nixpkgs.git
    else
      echo
      echo "${RED}Please install Git before continuing."
      exit 1
    fi
  fi

  ostype=$(uname)
  if [ -z "${ostype%CYGWIN*}" ] && git --version | grep -q msysgit; then
    fmt_error "Windows/MSYS Git is not supported on Cygwin"
    fmt_error "Make sure the Cygwin git package is installed and is first on the \$PATH"
    exit 1
  fi
}

_install_nix?() {
  if confirm "Would you like to use Nixpkg?"; then
    if ! command_exists? nix; then
      info_header "Installing Nix"
      cat << EOF
${YELLOW}Nix is not installed.${RESET}

Nix will be used to manage installing certain packages.
We will use Nix to temporarily install git to clone the repo.

Running the following command:
  
  $ bash -c "sh <(curl -L https://nixos.org/nix/install) --daemon"

EOF
      exec bash -c "sh <(curl -L https://nixos.org/nix/install) --daemon"
      return 0
    fi
  else
    return 1
  fi
}

main() {
  case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
      PLATFORM="linux"
      ;;
  darwin*)
      PLATFORM="macos"
      ;;
  msys*)
      PLATFORM="windows"
      fmt_error "Windows is not yet supported"
      exit 1
      ;;
  *)
      fmt_error "Unknown platform $(uname | tr '[:upper:]' '[:lower:]') not supported"
      exit 1
      ;;
  esac

  if [ -d "$DOTS" ]; then
    echo
    echo "${YELLOW}The \$DOTS folder already exists ($DOTS).${RESET}"
    echo "Skipping clone"
    echo
  else
    setup_dots
  fi

  cd "$DOTS"

  chmod +x bin/dots
  echo "${BLUE}Linking \"$PWD/bin/dots\" /usr/local/bin/dots"
  echo "> [sudo] required to run:"
  echo "> sudo ln -sf \"$PWD/bin/dots\" /usr/local/bin/dots${RESET}"
  sudo ln -sf "$PWD/bin/dots" "/usr/local/bin/${DOTS_NAME}"

  echo
  exec "${DOTS_NAME}" install ${INSTALL_FOR_SHELL}
}

main "$@"
