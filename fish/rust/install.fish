#!/usr/bin/env fish
if command -qa rustup
    rustup update
end

if command -qa cargo
    link_file $DOTFILES/fish/rust/config.toml $HOME/.cargo/config.toml backup
		or abort cargo config

    set -Ua fish_user_paths $HOME/.cargo/bin
end
