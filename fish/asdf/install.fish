#!/usr/bin/env fish
#
if ! command -qs asdf
	exit 0
end

switch (uname)
case Darwin
    if ! grep "source "(brew --prefix asdf)"/libexec/asdf.fish" ~/.config/fish/config.fish &> /dev/null
        echo -e "\nsource "(brew --prefix asdf)"/libexec/asdf.fish" >> ~/.config/fish/config.fish
    end
case '*'
	#source ~/.asdf/asdf.fish
    #mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
end


