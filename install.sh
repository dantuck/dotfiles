#!/bin/sh
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

is_tty() {
  test -t 1
}

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
  string="$1"
  color="${2:-BLUE}"
  desired_length=60

  num_dashes=$((desired_length - ${#string}))
  dashes=$(printf '%*s' "$num_dashes" | tr ' ' '-')

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

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

confirm() {
  question=$1
  default=${2:-Y}

  printf "$question [Y/n] "
  read -r response
  response=$(printf '%s' "$response" | tr '[:upper:]' '[:lower:]')

  if [ "$response" = "yes" ] || [ "$response" = "y" ] || [ -z "$response" ]; then
    return 0    # Confirmed
  else
    return 1    # Cancelled
  fi
}

setup_dots() {
  umask g-w,o-w

  info_header "Installing DOTS"
  cat << EOF
'dots' is a utility command to help manage your dotfiles,
keeping them updated and synced with any given git remotes.
EOF

  install_git
  clone
  
  echo
}

clone() {
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

install_git() {
  if ! command_exists git; then
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

    if install_nix; then
      nix-env -iA nixpkgs.git
    else
      echo
      echo "${RED}Please install Git before continuing."
      exit 1
    fi
  fi

  ostype=$(uname)
  if [ -z "${ostype#CYGWIN*}" ] && git --version | grep -q msysgit; then
    fmt_error "Windows/MSYS Git is not supported on Cygwin"
    fmt_error "Make sure the Cygwin git package is installed and is first on the \$PATH"
    exit 1
  fi
}

install_nix() {
  if confirm "Would you like to use Nixpkg?"; then
    if ! command_exists nix; then
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
    _setup_dots
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
