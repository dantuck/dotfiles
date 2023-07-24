#!/usr/bin/env fish
function result_divider
    if test $status -eq 0
        string repeat -N -m 12 '-'
        string pad -w(math $COLUMNS - 12) (echo [(set_color --bold green) ' OK ' (set_color normal)])
        set_color normal
    else
        set_color --bold yellow
        string repeat -N -m 12 '-'
        set_color normal
        string pad -w(math $COLUMNS - 12) (echo [(set_color --bold yellow) ABRT (set_color normal)])
	    return 1
    end
end
