#!/usr/bin/env fish
if test -f $HOME/.rover/bin/rover
	set -Ua fish_user_paths  $HOME/.rover/bin

    set -Ux APOLLO_TELEMETRY_DISABLED 1
end
