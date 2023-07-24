#!/usr/bin/env fish
function update -d ""
    section_header "Running updates"

    if command -qa apt
        action_header "sudo apt update && sudo apt upgrade" """
[sudo] is required to check for and run updates.
    """
        command sudo apt update && sudo apt upgrade
        result_divider
        if test $status -eq 1; return 1; end
    end

    if command -qa flatpak
        action_header "flatpak update --noninteractive"
        command flatpak update --noninteractive
        result_divider
        if test $status -eq 1; return 1; end
    end

    action_header "dots update"
    command dots update
end