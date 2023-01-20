#!/usr/bin/env fish
if command -qa iex
    set -Ux ERL_AFLAGS "-kernel shell_history enabled"

    abbr -a iexm 'iex -S mix'
end

if command -qa mix
    abbr -a mixdg 'mix deps.get'
end
