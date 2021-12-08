function dots
    switch $argv[1]
    case 'update'
        pushd $DOTFILES
        git pull

        fish $DOTFILES/fish/scripts/bootstrap.fish
        popd

    case '*'
        pushd $DOTFILES
        git pull
    end
end