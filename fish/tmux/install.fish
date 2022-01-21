#!/usr/bin/env fish
if command -qa tmux
	abbr -a tk 'tmux kill-server'
	abbr -a tls 'tmux ls'
end
