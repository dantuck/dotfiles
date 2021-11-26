[[ -z "$ZSH" ]] && export ZSH="${${(%):-%x}:a:h}"

export DOTFILES="$HOME/.dots"

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

################################################################################
# Initialize the autocompletion framework.
autoload -Uz compinit
if [[ -n ${XDG_CACHE_HOME}/zsh/zcompdump(#qN.mh+24) ]]; then
  compinit -i -d $XDG_CACHE_HOME/zsh/zcompdump;
else
  compinit -C $XDG_CACHE_HOME/zsh/zcompdump;
fi;

################################################################################
# Load Antibody Plugins
# source $XDG_DATA_HOME/zsh/plugins
# source $XDG_CONFIG_HOME/oh-my-zsh/oh-my-zsh.sh

# where should we store your Zsh plugins?
ZPLUGINDIR=$XDG_DATA_HOME/zsh/plugins

source $XDG_CONFIG_HOME/zsh/lib/plugin_load.zsh

# clone, source, and add to fpath
for repo in $plugins; do
    plugin-load https://github.com/${repo}.git
done
unset repo

unset config_files 

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ${XDG_CONFIG_HOME}/zsh/local.zsh ] && . ${XDG_CONFIG_HOME}/zsh/local.zsh

# . $HOME/.asdf/asdf.sh
