#!/usr/bin/env fish
function asdf -d "asdf: install it if you want it"
    echo "asdf: command not installed"

    switch (uname)
    case Darwin
        echo
        echo "Install with:"
        echo "  brew install asdf"
        echo "  dots update"
    case '*'
        echo "git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1"
    end

    return 1
end

funcsave asdf &> /dev/null

if ! command -qs asdf
	exit 0
end

functions --erase asdf &> /dev/null
funcsave asdf &> /dev/null

switch (uname)
case Darwin
    # Nothing needed
case '*'
    if ! grep "source ~/.asdf/asdf.fish" ~/.config/fish/config.fish &> /dev/null
        echo -e "\nsource ~/.asdf/asdf.fish" >> ~/.config/fish/config.fish
    end

    mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
end

# Add function wrapper so we can export variables
function asdf -d "asdf wrapper"
    set command $argv[1]
    set -e argv[1]

    switch "$command"
        case "alias"
            if echo (command asdf alias 2>&1 < /dev/null) | grep "Unknown command: `asdf alias` No plugin named alias" &> /dev/null
                echo "No plugin named alias"
                echo "Install with:"
                echo "  asdf plugin add alias https://github.com/andrewthauer/asdf-alias.git"

                return 1
            end

            # asdf alias erlang 22.3.4.26 22.3.4.22
            command asdf alias $argv
        case "shell"
            # source commands that need to export variables
            command asdf export-shell-version fish $argv | source # asdf_allow: source
        case '*'
            # forward other commands to asdf script
            command asdf "$command" $argv
    end
end

# Copied from /usr/local/opt/asdf/libexec/asdf.fish
if not set -q ASDF_DIR
  set -x ASDF_DIR (dirname (status -f))
end

# Add asdf to PATH
# fish_add_path was added in fish 3.2, so we need a fallback for older version
if type -q fish_add_path
  if test -n "$ASDF_DATA_DIR"
    fish_add_path --global --move "$ASDF_DATA_DIR/shims" "$ASDF_DIR/bin"
  else
    fish_add_path --global --move "$HOME/.asdf/shims" "$ASDF_DIR/bin"
  end
else
  set -l asdf_user_shims (
    if test -n "$ASDF_DATA_DIR"
      printf "%s\n" "$ASDF_DATA_DIR/shims"
    else
      printf "%s\n" "$HOME/.asdf/shims"
    end
  )

  set -l asdf_bin_dirs $ASDF_DIR/bin $asdf_user_shims

  for x in $asdf_bin_dirs
    if test -d $x
      for i in (seq 1 (count $PATH))
        if test $PATH[$i] = $x
          set -e PATH[$i]
          break
        end
      end
    end
    set PATH $x $PATH
  end
end

funcsave asdf &> /dev/null
