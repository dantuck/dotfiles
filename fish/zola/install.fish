#!/usr/bin/env fish
function zola
    flatpak run org.getzola.zola $argv
end

function remove_zola
    functions --erase zola
    funcsave zola
end

if ! command -qs flatpak
    remove_zola
    exit 0
end

if ! set command_output (flatpak info org.getzola.zola)
    remove_zola
    exit 0
end

funcsave zola
