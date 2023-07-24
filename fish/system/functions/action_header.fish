#!/usr/bin/env fish
function action_header
    echo [(set_color --bold green) 'RUNNING' (set_color normal)] $argv[1]
    if test (count $argv) -ge 2
        pretty_print $argv[2]
    end
    echo
end
