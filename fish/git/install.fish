#!/usr/bin/env fish

# Don't ask ssh password all the time
switch (uname)
case Darwin
	git config --global credential.helper osxkeychain
case '*'
	git config --global credential.helper cache
end

# better diffs
if command -qs delta
	git config --global core.pager delta
	git config --global interactive.diffFilter 'delta --color-only'
	git config --global delta.syntax-theme Dracula
	git config --global delta.line-numbers true
	git config --global delta.decorations true
end

# use vscode as mergetool
if command -qs code
	git config --global merge.tool vscode
		and git config --global mergetool.vscode.cmd "code --wait $MERGED"
end

if command -qs gh
	abbr -a 'grv' 'gh repo view -w'
	abbr -a 'gpv' 'gh pr view -w'
end

abbr -a g 'git'
abbr -a ga 'git add'
abbr -a gaa 'git add .'
abbr -a gaaa 'git add --all'
abbr -a gau 'git add --update'
abbr -a gb 'git branch -v'
abbr -a gbd 'git branch --delete'
abbr -a gc 'git commit -s'
abbr -a gca 'git commit -sa'
abbr -a gcm 'git commit -sm'
abbr -a gcam 'git commit -sam'
abbr -a gco 'git checkout'
abbr -a gcob 'git checkout -b'
abbr -a gd 'git diff'
abbr -a gda 'git diff HEAD'
abbr -a glg 'git log --graph --decorate --oneline --abbrev-commit'
abbr -a glga "glg --all"
abbr -a gld 'git log --pretty=format:"%h %ad %s" --date=short --all'
abbr -a glnext 'git log --oneline (git describe --tags --abbrev=0 @^)..@'
abbr -a gl 'git pull --prune'
abbr -a gp 'git push origin HEAD'
abbr -a gpa 'git push origin --all'
abbr -a gs 'git status -sb'
abbr -a gst 'git stash'
abbr -a gsta 'git stash apply'
abbr -a gstd 'git stash drop'
abbr -a gstl 'git stash list'
abbr -a gstp 'git stash pop'
abbr -a gsts  'git stash save'
abbr -a gw 'git switch'
abbr -a gm 'git switch (git main-branch)'
abbr -a gms 'git switch (git main-branch); and git sync'
abbr -a egms 'e; git switch (git main-branch); and git sync'
abbr -a gwc 'git switch -c'
