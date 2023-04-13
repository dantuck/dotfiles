#!/bin/sh
#
# This script should be run via curl:
#   curl -fsSL https://codeberg.org/tuck/dotfiles/raw/branch/main/nushell/install.sh | sh"
#
# As an alternative, you can first download the install script and run it afterwards:
#   wget https://codeberg.org/tuck/dotfiles/raw/branch/main/nushell/install.sh
#   sh install.sh
#
# You can tweak the install behavior by setting variables when running the script. For
# example, to change the path to the Oh My Zsh repository:
#   DOTS=~/.dotfiles sh install.sh
#
# Respects the following environment variables:
#   DOTS     - path to the Oh My Zsh repository folder (default: $HOME/.dots)
#   REPO    - name of the Codeberg repo to install from (default: dantuck/dotfiles)
#   REMOTE  - full remote URL of the git repo to install (default: Codeberg via HTTPS)
#   BRANCH  - branch to check out immediately after install (default: main)
#
set -e

# Default settings
DOTS=${DOTS:-~/.dots}
REPO=${REPO:-tuck/dotfiles}
REMOTE=${REMOTE:-https://codeberg.org/${REPO}.git}
BRANCH=${BRANCH:-main}

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

fmt_error() {
  printf '%sError: %s%s\n' "$BOLD$RED" "$*" "$RESET" >&2
}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

setup_color() {
  # Only use colors if connected to a terminal
  if is_tty; then
    RAINBOW="
      $(printf '\033[38;5;196m')
      $(printf '\033[38;5;202m')
      $(printf '\033[38;5;226m')
      $(printf '\033[38;5;082m')
      $(printf '\033[38;5;021m')
      $(printf '\033[38;5;093m')
      $(printf '\033[38;5;163m')
    "
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
  else
    RAINBOW=""
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    RESET=""
  fi
}

setup_dots() {
  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  echo "${BLUE}Cloning dots...${RESET}"

  command_exists git || {
    fmt_error "git is not installed"
    exit 1
  }

  ostype=$(uname)
  if [ -z "${ostype%CYGWIN*}" ] && git --version | grep -q msysgit; then
    fmt_error "Windows/MSYS Git is not supported on Cygwin"
    fmt_error "Make sure the Cygwin git package is installed and is first on the \$PATH"
    exit 1
  fi

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

  cd ${DOTS}

  echo
}

main() {
  setup_color

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
    echo "\n${YELLOW}The \$DOTS folder already exists ($DOTS).${RESET}"
    if [ "$custom_zsh" = yes ]; then
      cat <<EOF

You ran the installer with the \$DOTS setting or the \$DOTS variable is
exported. You have 3 options:

1. Unset the DOTS variable when calling the installer:
   $(fmt_code "DOTS= sh install.sh")
2. Install Dots to a directory that doesn't exist yet:
   $(fmt_code "DOTS=path/to/new/dots/folder sh install.sh")
3. (Caution) If the folder doesn't contain important information,
   you can just remove it with $(fmt_code "rm -r $DOTS")

EOF
    else
      echo "Skipping clone.\n"
    fi
  else
    setup_dots
  fi

  cd $DOTS

  chmod +x dots
  echo "${BLUE}Linking \"$PWD/dots\" /usr/local/bin/dots"
  echo "> [sudo] required to run:"
  echo "> sudo ln -sf \"$PWD/dots\" /usr/bin/dots${RESET}"
  sudo ln -sf "$PWD/dots" /usr/bin/dots

  echo
  exec ./dots
}

main "$@"
