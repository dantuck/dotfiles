#!/usr/bin/env fish

function test_version
    set regex_semver '[0-9]+\.[0-9]+\.[0-9]+'

    set zellij_version (zellij --version | string match --regex $regex_semver)
    set zellij_version_info (string split . $zellij_version)
    set zellij_version_major $zellij_version_info[1]
    set zellij_version_minor $zellij_version_info[2]
    set zellij_version_patch $zellij_version_info[3]

    if test $zellij_version_minor -lt 36
        abort "please update zellij: `cargo install --locked zellij`"
    end
end

if command -qa zellij
    for f in $DOTFILES/fish/scripts/helpers
        set -Up fish_function_path $f
    end

    test_version

    set -Ux ZELLIJ_CONFIG_DIR $DOTFILES/fish/zellij
end
