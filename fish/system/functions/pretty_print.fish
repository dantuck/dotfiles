#!/usr/bin/env fish

function pretty_print
    set padding 2
    set indent 20

    # Create left indentation
    set left_indent (string repeat -m $padding " ")

    # Wrap the text and add the left indentation
    echo -n $argv | fold -sw (math $COLUMNS - $padding - $indent) | sed "s/^/$left_indent/"
end
