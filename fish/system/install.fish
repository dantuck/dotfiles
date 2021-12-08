#!/usr/bin/env fish
set -Ux EDITOR vim
set -Ux VISUAL $EDITOR
set -Ux WEDITOR code

set -Ux DOTFILES ~/.dots

set -Ua fish_user_paths $DOTFILES/fish/bin $HOME/.bin

for f in $DOTFILES/fish/*/functions
	echo $f
	set -Up fish_function_path $f
end

for f in $DOTFILES/fish/*/conf.d/*.fish
	ln -sf $f ~/.config/fish/conf.d/(basename $f)
end

if test -f ~/.localrc.fish
	ln -sf ~/.localrc.fish ~/.config/fish/conf.d/localrc.fish
end

for f in ~/.extra/functions
	set -Up fish_function_path $f
end

abbr -a c 'clear'
abbr -a mb 'mkdir -p'
abbr -a rd 'rmdir'