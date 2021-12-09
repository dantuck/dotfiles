#!/usr/bin/env fish
#
if ! command -qs code
	exit 0
end

function success
	echo [(set_color --bold green) ' OK ' (set_color normal)] $argv
end

switch (uname)
case Darwin
	set vscode_home "$HOME/Library/Application Support/Code"
case '*'
	set vscode_home "$HOME/.config/Code"
end

mkdir -p $vscode_home
	and ln -sf "$DOTFILES/vscode/snippets" "$vscode_home/User/"
	and success "linked vscode config files"
