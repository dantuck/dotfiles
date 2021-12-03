function update
  git pull
  fish $DOTFILES/fish/scripts/bootstrap.fish
end