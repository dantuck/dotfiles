function dots -d "dots management utility"
    switch $argv[1]
    case 'u'
        pushd $DOTFILES
        git pull

        fish $DOTFILES/fish/scripts/bootstrap.fish
        popd

    case '*'
        pushd $DOTFILES
        git pull
    end
end

set -l dots_commands update
complete -f --command dots
complete -f --command dots -n "not __fish_seen_subcommand_from $dots_commands" -a update -d 'update dots'
