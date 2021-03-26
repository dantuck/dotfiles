#! /usr/bin/env zsh

export DOTFILES="$HOME/.dotfiles"

typeset -U config_files
config_files=($XDG_CONFIG_HOME/*/*.zsh)

################################################################################
# Load the env files
for file in ${(M)config_files:#*/env.zsh}; do
  source "$file"
done

################################################################################
# Load everything but the env files.
for file in ${config_files:#*/env.zsh}; do
  source "$file"
done

unset config_files 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ${XDG_CONFIG_HOME}/zsh/local.zsh ] && . ${XDG_CONFIG_HOME}/zsh/local.zsh