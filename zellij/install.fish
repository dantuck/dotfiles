#!/usr/bin/env fish

switch (uname)
case Darwin
    link_file config.yaml "$HOME/Application Support/org.Zellij-Contributors.Zellij/config.yml" backup
case '*'
    link_file config.yaml $HOME/.config/zellij/config.yml backup
end