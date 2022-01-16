#!/usr/bin/env fish
if command -qa rustup
    rustup update
end

if command -qa cargo
    set -Ua fish_user_paths $HOME/.cargo/bin
end