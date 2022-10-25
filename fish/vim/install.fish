#!/usr/bin/env fish
if command -qs hx
	exit 0
end

curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugUpdate | PlugInstall --sync' +qa