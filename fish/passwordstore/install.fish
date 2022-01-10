#!/usr/bin/env fish
if command -qa pass
    abbr -a passc 'pass -c'
    abbr -a passe 'pass edit'
    abbr -a passs 'pass show'
end
