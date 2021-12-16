function dots -d "dots management utility"
    switch $argv[1]
    case 'update'
        pushd $DOTFILES
        git pull

        fish $DOTFILES/fish/scripts/bootstrap.fish
        popd

    case 'cd' '*'
        pushd $DOTFILES
        git pull
    end
end

set -l dots_commands update cd
complete -f --command dots
complete -f --command dots -n "not __fish_seen_subcommand_from $dots_commands" -a update -d 'update dots'
complete -f --command dots -n "not __fish_seen_subcommand_from $dots_commands" -a cd -d 'cd into dots and pull'
