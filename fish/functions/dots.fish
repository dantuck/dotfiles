function dots_fish -d "dots management utility"
    switch $argv[1]
    case 'update'
        pushd $DOTFILES
        git pull

        fish $DOTFILES/fish/scripts/bootstrap.fish
        popd

    case 'reload'
    case 'reload!'
        reload!

    case 'config'
        $EDITOR ~/.config/fish/config.fish

    case 'cd' '*'
        pushd $DOTFILES
        git pull
    end
end

set -l dots_commands update cd
complete -f --command dots
complete -f --command dots -n "not __fish_seen_subcommand_from $dots_commands" -a update -d 'update dots'
complete -f --command dots -n "not __fish_seen_subcommand_from $dots_commands" -a cd -d 'cd into dots and pull'
complete -f --command dots -n "not __fish_seen_subcommand_from $dots_commands" -a reload! -d 'reload shell'
complete -f --command dots -n "not __fish_seen_subcommand_from $dots_commands" -a config -d 'edit fish config'
