#!/usr/bin/env fish
function zola
    flatpak run org.getzola.zola $argv
end

function remove_zola
    functions --erase zola
end

if ! command -qs flatpak
    remove_zola
end

if ! set command_output (flatpak info org.getzola.zola)
    remove_zola
end


funcsave zola
