#!/usr/bin/env fish
set DOTFILES_ROOT (pwd -P)

for f in $DOTFILES/fish/scripts/helpers
	set -Up fish_function_path $f
end

function notes -d "logseq: install it if you want it"
    echo (set_color blue)"logseq:"(set_color brblack)" command not installed"(set_color normal)

    switch (uname)
    case Darwin
        echo
        echo "Install with:"
        echo "  not sure yet"
    case '*'
        echo (set_color blue)"[i]> Install with:"(set_color normal)
        echo (set_color blue)"-------------"(set_color normal)
        
        echo "mkdir -p ~/.local/bin/"
        echo "curl -o ~/.local/bin/logseq https://github.com/logseq/logseq/releases/download/0.10.3/Logseq-linux-x64-0.10.3.AppImage"
        
        echo (set_color blue)"-------------"(set_color normal)
    end

    return 1
end

funcsave notes &> /dev/null

if ! command -qs logseq
	exit 0
end

functions --erase notes &> /dev/null
funcsave notes &> /dev/null

function notes -d "notes: logseq entrypoint"
    set command $argv[1]
    set -e argv[1]

    function run_logseq
        echo (set_color --bold brblue)"> Running logseq. ctrl+c to close" (set_color normal)
        command logseq &> /dev/null
        echo

        pushd "$NOTES_DIR"
        command git add -A && git commit -m "Autosync from fishshell"
        command git push -u origin main
        prevd
    end

    echo (set_color --bold brblack)"[i]-> Pulling notes vault" (set_color normal)

    pushd "$NOTES_DIR"
    git pull --rebase &> /dev/null

    if test ! "$status" -eq 0
        echo (set_color --bold red)"[e]-> git pull --rebased" (set_color normal)
        echo (set_color red)"-------------" (set_color normal)
        command git pull --rebase
        echo (set_color red)"-------------" (set_color normal)
        command git fetch origin main
        command git diff main origin/main
        echo
        popd
        echo (set_color blue)"[i]> ctrl+c to abort"(set_color normal)
        while read --nchars 1 -l response --prompt-str="Overwrite from Origin (t), or Stash and Apply(s)? (t/s)"
            or return 1 # if the read was aborted with ctrl-c/ctrl-d
            switch $response
                case t
                    pushd "$NOTES_DIR"
                    command git reset --hard @{u}
                    popd
                    run_logseq
                    break
                case s
                    echo Stash and Apply
                    pushd "$NOTES_DIR"
                    command git stash && git pull --rebase && git stash pop
                    popd
                    run_logseq
                    break
                case '*'
                    echo Not valid input
                    continue
            end
        end
    else
        run_logseq
    end
end

if not set -q NOTES_DIR
    while read -l response --prompt-str="Enter your logseq vault absolute path > "
            or return 1 # if the read was aborted with ctrl-c/ctrl-d
        if test -d $response
            set -Ux NOTES_DIR "$response"
            break
        else
            echo Oops, not a valid path.
            continue
        end
    end
end

funcsave notes &> /dev/null
