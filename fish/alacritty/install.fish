#!/usr/bin/env fish

function cp_override -d "copy alacritty override to extra"
    switch (uname)
    case Darwin
        cp $DOTFILES/fish/alacritty/osx.override.yml ~/.extra/alacritty.override.yml
    case '*'
        cp $DOTFILES/fish/alacritty/linux.override.yml ~/.extra/alacritty.override.yml
    end
end

link_file $DOTFILES/fish/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml backup
    or abort alacritty link

test -e ~/.extra/alacritty.override.yml
    and success "~/.extra/alacritty.override.yml exists"
    or cp_override


