function update
  pushd $DOTFILES
  git pull

  fish $DOTFILES/fish/scripts/bootstrap.fish
  popd
end