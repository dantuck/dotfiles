# open ~/.zshrc in using the default editor specified in $EDITOR
alias ec="$EDITOR $DOTFILES/.zshrc"

# source ~/.zshrc
alias sc="source $HOME/.zshrc"

alias md='mkdir -p'
alias rd='rmdir'

alias c='clear'

# ---- dotfile git pull ----
alias dotpull="pwd=`pwd` && cd $DOTFILES && git pull && sleep 6 && cd $pwd"

# ---- dotfile git push ----
alias dotpush="cd $DOTFILES && gaa && gcmsg 'update dotfiles' && git push origin master && cd -"

# ---- dotfile cd ----
alias dot="cd $DOTFILES"

alias docker_rm_all="docker rm \`docker ps -a -q\`"
alias docker_rmi_all="docker rmi \`docker images -q\`"
alias docker_rmi_dangling="docker rmi \`docker images -qa -f 'dangling=true'\`"

alias td="todo.sh"