#!/usr/bin/env fish
if command -qa pnpm
	abbr -a npm 'pnpm'
	set -Ux MANPAGER "sh -c 'col -bx | pnpm -l man -p'"

    abbr -a npx 'pnpm exec'
end
