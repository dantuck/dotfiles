#!/usr/bin/env fish
if ! test -e $HOME/.rover/bin/rover
	exit 0
end

fish_add_path $HOME/.rover/bin

set -Ux APOLLO_TELEMETRY_DISABLED 1
