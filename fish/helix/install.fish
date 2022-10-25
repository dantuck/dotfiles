#!/usr/bin/env fish
if ! command -qs hx
	exit 0
end

for f in $DOTFILES/fish/scripts/helpers
	set -Up fish_function_path $f
end

hx --grammar fetch &>/dev/null
    and success 'helix grammar fetched'

hx --grammar build &>/dev/null
    and success 'helix grammar build'

abbr -a vim hx
abbr -a vi hx
