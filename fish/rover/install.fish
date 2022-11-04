#!/usr/bin/env fish
if test -f $HOME/.rover/bin/rover
	fish_add_path -aP $HOME/.rover/bin

    set -Ux APOLLO_TELEMETRY_DISABLED 1
end
