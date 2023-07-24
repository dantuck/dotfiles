#!/usr/bin/env fish
function section_header
    set ARG_LENGTH (math $COLUMNS - (string length $argv) - 3)

	echo (set_color --bold blue)(string repeat -m $COLUMNS '=')
    
    echo -n '== '(set_color --bold green)$argv(set_color --bold blue)
    string pad -w$ARG_LENGTH '=='

    string repeat -m $COLUMNS '='
    echo -n (set_color normal)
end
