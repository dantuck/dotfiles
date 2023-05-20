#!/bin/bash

set -e

DOTS=${DOTS:-~/.dots}

source "$DOTS/util/functions.sh"

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

_set_default_shell() {
	local line=$(command -v fish)
	local file="/etc/shells"

	info_header "Set default shell (sudo)"

	write_line_to_file_if_not_exists "${line}" "${file}"

	echo "Changing default shell to fish"
	chsh -s "${line}"
}

_install_nix?() {
  if ! command_exists? nix; then
    info_header "Install Nix?"
    cat << EOF
${YELLOW}Nix is not installed.${RESET}
The following command would be ran:
  
  $ bash -c "sh <(curl -L https://nixos.org/nix/install) --daemon"

EOF
    if confirm? "Can I install it for you?"; then
      exec bash -c "sh <(curl -L https://nixos.org/nix/install) --daemon"
      _reload
    else
      echo
      info_header "Install Nix?" "YELLOW"
      echo "${RED}Please install Nix before continuing."
      exit 1
    fi
  fi
}

_install_home_manager?() {
  if ! command_exists? home-manager; then
    info_header "Install Home Manager?"
    cat << EOF
${YELLOW}home-manager is not installed.${RESET}
The following command would be ran:
  
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update

EOF
    if confirm? "Can I install it for you?"; then
      nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update
      _reload
    else
      info_header "Install Home Manager?" "YELLOW"
      echo "${RED}Please install home-manager before continuing."
      exit 1
    fi
  fi
}

_link_nix_home() {
  info_header "Link nix/home.nix"

  cat << EOF
The following command would be ran:
  
  ln -sf "$PWD/nix/home.nix" ~/.config/home-manager/home.nix

EOF

  ln -sf "$PWD/nix/home.nix" ~/.config/home-manager/home.nix
}

main() {
  _install_nix?
  _install_home_manager?
  _link_nix_home

  home-manager switch

  _set_default_shell
}

main "$@"
