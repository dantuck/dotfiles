#!/usr/bin/env fish

function cp_to_extra -d "copy to extra"
    echo $argv | read -l src dest
    test -e $dest
        and success "skipped $src"
        or cp $src $dest
        and success "copied $src to $dest"
end

cp_to_extra $DOTFILES/fish/alacritty/alacritty.local.toml $HOME/.extra/alacritty.local.toml

link_file $DOTFILES/fish/alacritty/alacritty.defaults.toml $HOME/.config/alacritty/alacritty.defaults.toml backup
    or abort alacritty link

link_file $HOME/.extra/alacritty.local.toml $HOME/.config/alacritty/alacritty.toml backup
    or abort alacritty link

switch (uname)
case Darwin
    cp_to_extra $DOTFILES/fish/alacritty/osx.shell.toml $HOME/.extra/alacritty.shell.toml
case '*'
    cp_to_extra  $DOTFILES/fish/alacritty/linux.shell.yml $HOME/.extra/alacritty.shell.yml
end

# test -e ~/.extra/alacritty.override.yml
#     and success "~/.extra/alacritty.override.yml exists"
#     or cp_override




# (
#             switch (uname)
#             case Darwin
#                 cp $DOTFILES/fish/alacritty/osx.override.yml ~/.extra/alacritty.override.yml
#             case '*'
#                 cp $DOTFILES/fish/alacritty/linux.override.yml ~/.extra/alacritty.override.yml
#             end
#         )

complete -c alacritty -n "__fish_use_subcommand" -l embed -d 'X11 window ID to embed Alacritty within (decimal or hexadecimal with "0x" prefix)' -r
complete -c alacritty -n "__fish_use_subcommand" -l config-file -d 'Specify alternative configuration file [default: $XDG_CONFIG_HOME/alacritty/alacritty.toml]' -r -F
complete -c alacritty -n "__fish_use_subcommand" -l socket -d 'Path for IPC socket creation' -r -F
complete -c alacritty -n "__fish_use_subcommand" -l working-directory -d 'Start the shell in the specified working directory' -r -F
complete -c alacritty -n "__fish_use_subcommand" -s e -l command -d 'Command and args to execute (must be last argument)' -r
complete -c alacritty -n "__fish_use_subcommand" -s T -l title -d 'Defines the window title [default: Alacritty]' -r
complete -c alacritty -n "__fish_use_subcommand" -l class -d 'Defines window class/app_id on X11/Wayland [default: Alacritty]' -r
complete -c alacritty -n "__fish_use_subcommand" -s o -l option -d 'Override configuration file options [example: \'cursor.style="Beam"\']' -r
complete -c alacritty -n "__fish_use_subcommand" -l print-events -d 'Print all events to STDOUT'
complete -c alacritty -n "__fish_use_subcommand" -l ref-test -d 'Generates ref test'
complete -c alacritty -n "__fish_use_subcommand" -s q -d 'Reduces the level of verbosity (the min level is -qq)'
complete -c alacritty -n "__fish_use_subcommand" -s v -d 'Increases the level of verbosity (the max level is -vvv)'
complete -c alacritty -n "__fish_use_subcommand" -l hold -d 'Remain open after child process exit'
complete -c alacritty -n "__fish_use_subcommand" -s h -l help -d 'Print help'
complete -c alacritty -n "__fish_use_subcommand" -s V -l version -d 'Print version'
complete -c alacritty -n "__fish_use_subcommand" -f -a "msg" -d 'Send a message to the Alacritty socket'
complete -c alacritty -n "__fish_use_subcommand" -f -a "migrate" -d 'Migrate the configuration file'
complete -c alacritty -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from help" -s s -l socket -d 'IPC socket connection path override' -r -F
complete -c alacritty -n "__fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from help" -s h -l help -d 'Print help'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from help" -f -a "create-window" -d 'Create a new window in the same Alacritty process'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from help" -f -a "config" -d 'Update the Alacritty configuration'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from create-window" -l working-directory -d 'Start the shell in the specified working directory' -r -F
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from create-window" -s e -l command -d 'Command and args to execute (must be last argument)' -r
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from create-window" -s T -l title -d 'Defines the window title [default: Alacritty]' -r
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from create-window" -l class -d 'Defines window class/app_id on X11/Wayland [default: Alacritty]' -r
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from create-window" -s o -l option -d 'Override configuration file options [example: \'cursor.style="Beam"\']' -r
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from create-window" -l hold -d 'Remain open after child process exit'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from create-window" -s h -l help -d 'Print help'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from config" -s w -l window-id -d 'Window ID for the new config' -r
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from config" -s r -l reset -d 'Clear all runtime configuration changes'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from config" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from help" -f -a "create-window" -d 'Create a new window in the same Alacritty process'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from help" -f -a "config" -d 'Update the Alacritty configuration'
complete -c alacritty -n "__fish_seen_subcommand_from msg; and __fish_seen_subcommand_from help; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c alacritty -n "__fish_seen_subcommand_from migrate" -s c -l config-file -d 'Path to the configuration file' -r -F
complete -c alacritty -n "__fish_seen_subcommand_from migrate" -s d -l dry-run -d 'Only output TOML config to STDOUT'
complete -c alacritty -n "__fish_seen_subcommand_from migrate" -s i -l skip-imports -d 'Do not recurse over imports'
complete -c alacritty -n "__fish_seen_subcommand_from migrate" -l skip-renames -d 'Do not move renamed fields to their new location'
complete -c alacritty -n "__fish_seen_subcommand_from migrate" -s s -l silent -d 'Do not output to STDOUT'
complete -c alacritty -n "__fish_seen_subcommand_from migrate" -s h -l help -d 'Print help'
complete -c alacritty -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from help" -f -a "msg" -d 'Send a message to the Alacritty socket'
complete -c alacritty -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from help" -f -a "migrate" -d 'Migrate the configuration file'
complete -c alacritty -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from migrate; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c alacritty -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config" -f -a "create-window" -d 'Create a new window in the same Alacritty process'
complete -c alacritty -n "__fish_seen_subcommand_from help; and __fish_seen_subcommand_from msg; and not __fish_seen_subcommand_from create-window; and not __fish_seen_subcommand_from config" -f -a "config" -d 'Update the Alacritty configuration'
