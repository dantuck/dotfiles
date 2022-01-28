#!/usr/bin/env fish
set -Ux EDITOR vim
set -Ux VISUAL $EDITOR
set -Ux WEDITOR code
set -U fish_greeting

set -Ux DOTFILES ~/.dots

set -Ua fish_user_paths $DOTFILES/fish/bin $HOME/.bin

for f in $DOTFILES/fish/**/functions
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

abbr --erase c
abbr -a mb 'mkdir -p'
abbr -a rd 'rmdir'
