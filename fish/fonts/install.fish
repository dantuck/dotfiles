#!/usr/bin/env fish
if test -e ~/.local/share/fonts/Inconsolata[wdth,wght].ttf ||
	test -e ~/Library/Fonts/Inconsolata[wdth,wght].ttf
	exit 0
end

function install
	curl -Lso $argv[1]/FiraCodeRegularNerdFontComplete.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
end

switch (uname)
case Darwin
	if command -qs brew
		brew tap homebrew/cask-fonts &&
			and brew install --cask font-firacode-nerd-font
	else
		install ~/Library/Fonts
	end
case '*'
	mkdir -p ~/.local/share/fonts/
		and install ~/.local/share/fonts/
	if command -qs fc-cache
		fc-cache -fv
	end
end
