#!/bin/sh
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://gitlab.com/dantuck/dotfiles/-/raw/fish/utils/install.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://gitlab.com/dantuck/dotfiles/-/raw/fish/utils/install.sh)"
# or via fetch:
#   sh -c "$(fetch -o - https://gitlab.com/dantuck/dotfiles/-/raw/fish/utils/install.sh)"
#
# As an alternative, you can first download the install script and run it afterwards:
#   wget https://gitlab.com/dantuck/dotfiles/-/raw/fish/utils/install.sh
#   sh install.sh
#
# You can tweak the install behavior by setting variables when running the script. For
# example, to change the path to the Oh My Zsh repository:
#   ZSH=~/.zsh sh install.sh
#
# Respects the following environment variables:
#   ZSH     - path to the Oh My Zsh repository folder (default: $HOME/.oh-my-zsh)
#   REPO    - name of the GitHub repo to install from (default: ohmyzsh/ohmyzsh)
#   REMOTE  - full remote URL of the git repo to install (default: GitHub via HTTPS)
#   BRANCH  - branch to check out immediately after install (default: main)
#
# Other options:
#   CHSH       - 'no' means the installer will not change the default shell (default: yes)
#   RUNZSH     - 'no' means the installer will not run zsh after the install (default: yes)
#   KEEP_ZSHRC - 'yes' means the installer will not replace an existing .zshrc (default: no)
#
# You can also pass some arguments to the install script to set some these options:
#   --skip-chsh: has the same behavior as setting CHSH to 'no'
#   --unattended: sets both CHSH and RUNZSH to 'no'
#   --keep-zshrc: sets KEEP_ZSHRC to 'yes'
# For example:
#   sh install.sh --unattended
# or:
#   sh -c "$(curl -fsSL https://gitlab.com/dantuck/dotfiles/-/raw/main/utils/install.sh)" "" --unattended
#
set -e

# Default settings
DOTS=${DOTS:-~/.dots}
FISH=${ZSH:-${DOTS}/fish}
REPO=${REPO:-dantuck/dotfiles}
REMOTE=${REMOTE:-https://gitlab.com/${REPO}.git}
BRANCH=${BRANCH:-fish}

# Other options
CHSH=${CHSH:-yes}
# KEEP_ZSHRC=${KEEP_ZSHRC:-no}


command_exists() {
  command -v "$@" >/dev/null 2>&1
}

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

# This function uses the logic from supports-hyperlinks[1][2], which is
# made by Kat Marchán (@zkat) and licensed under the Apache License 2.0.
# [1] https://github.com/zkat/supports-hyperlinks
# [2] https://crates.io/crates/supports-hyperlinks
#
# Copyright (c) 2021 Kat Marchán
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
supports_hyperlinks() {
  # $FORCE_HYPERLINK must be set and be non-zero (this acts as a logic bypass)
  if [ -n "$FORCE_HYPERLINK" ]; then
    [ "$FORCE_HYPERLINK" != 0 ]
    return $?
  fi

  # If stdout is not a tty, it doesn't support hyperlinks
  is_tty || return 1

  # DomTerm terminal emulator (domterm.org)
  if [ -n "$DOMTERM" ]; then
    return 0
  fi

  # VTE-based terminals above v0.50 (Gnome Terminal, Guake, ROXTerm, etc)
  if [ -n "$VTE_VERSION" ]; then
    [ $VTE_VERSION -ge 5000 ]
    return $?
  fi

  # If $TERM_PROGRAM is set, these terminals support hyperlinks
  case "$TERM_PROGRAM" in
  Hyper|iTerm.app|terminology|WezTerm) return 0 ;;
  esac

  # kitty supports hyperlinks
  if [ "$TERM" = xterm-kitty ]; then
    return 0
  fi

  # Windows Terminal or Konsole also support hyperlinks
  if [ -n "$WT_SESSION" ] || [ -n "$KONSOLE_VERSION" ]; then
    return 0
  fi

  return 1
}

fmt_link() {
  # $1: text, $2: url, $3: fallback mode
  if supports_hyperlinks; then
    printf '\033]8;;%s\a%s\033]8;;\a\n' "$2" "$1"
    return
  fi

  case "$3" in
  --text) printf '%s\n' "$1" ;;
  --url|*) fmt_underline "$2" ;;
  esac
}

fmt_underline() {
  is_tty && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

# shellcheck disable=SC2016 # backtick in single-quote
fmt_code() {
  is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_error() {
  printf '%sError: %s%s\n' "$BOLD$RED" "$*" "$RESET" >&2
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

setup_xdg() {
  export XDG_CONFIG_HOME=${HOME}/.config
  export XDG_CACHE_HOME=${HOME}/.cache
  export XDG_DATA_HOME=${HOME}/.local/share
  export XDG_RUNTIME_DIR=${HOME}/tmp/xdg_runtime
}

setup_dots() {
  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  echo "${BLUE}Cloning dantuck fish dots...${RESET}"

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

  # git clone -c core.eol=lf -c core.autocrlf=false \
  #   -c fsck.zeroPaddedFilemode=ignore \
  #   -c fetch.fsck.zeroPaddedFilemode=ignore \
  #   -c receive.fsck.zeroPaddedFilemode=ignore \
  #   -c dots.remote=origin \
  #   -c dots.branch="$BRANCH" \
  #   --depth=1 --branch "$BRANCH" "$REMOTE" "$DOTS" || {
  #   fmt_error "git clone of dantuck dots repo failed"
  #   exit 1
  # }

  cd ${DOTS}

  # make all

  

  echo
}

# shellcheck disable=SC2183  # printf string has more %s than arguments ($RAINBOW expands to multiple arguments)
print_success() {
  printf '\n'
  printf '\n'
  # printf "%s %s %s\n" "Look over the" \
  #   "$(fmt_code "$(fmt_link ".zshrc" "file://$HOME/.zshrc" --text)")" \
  #   "file to select plugins, themes, and options."
  # printf '\n'
  printf '%s\n' $RESET
}

main() {
  setup_color

  if ! command_exists fish; then
    echo "${YELLOW}Fish is not installed.${RESET} Please install fish first."
    exit 1
  fi

  if [ -d "$DOTS" ]; then
    echo "${YELLOW}The \$DOTS folder already exists ($DOTS).${RESET}"
    if [ "$custom_zsh" = yes ]; then
      cat <<EOF

You ran the installer with the \$ZSH setting or the \$ZSH variable is
exported. You have 3 options:

1. Unset the ZSH variable when calling the installer:
   $(fmt_code "ZSH= sh install.sh")
2. Install Dots to a directory that doesn't exist yet:
   $(fmt_code "ZSH=path/to/new/dots/folder sh install.sh")
3. (Caution) If the folder doesn't contain important information,
   you can just remove it with $(fmt_code "rm -r $DOTS")

EOF
    else
      echo "You'll need to remove it if you want to reinstall."
    fi
    # exit 1
  fi

  setup_dots
  print_success

  # exec fish -l

  exec fish -l ${DOTS}/fish/scripts/bootstrap.fish
}

main "$@"
