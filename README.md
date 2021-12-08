## Setup

## Fish

### Getting started

```fish
curl -fsSL https://gitlab.com/dantuck/dotfiles/-/raw/main/fish/scripts/install.sh | sh
```

or

```bash
sh -c "$(curl -fsSL https://gitlab.com/dantuck/dotfiles/-/raw/main/fish/scripts/install.sh)"
```

### Install fish

Official [website](https://fishshell.com) or check out some snippets below.

<details>
<summary>macOS with homebrew</summary>

```bash
brew update && brew install fish
```

</details>

<details>
<summary>Ubuntu: fish shell - 3.x release series </summary>

```bash
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish

chsh -s /usr/bin/fish
```

</details>

## ZSH

### Getting started

```bash
sh -c "$(curl -fsSL https://gitlab.com/dantuck/dotfiles/-/raw/main/utils/install.sh)"
```

### Setup dotfile components

*NOTE*: Make sure if needed to create local files first:
 - git: [user] name and email and [url] instead of mapping
 - zsh: environment variables with usernames and tokens set.

```shell
.dotfiles/git/config.local
.dotfiles/zsh/local.zsh
```

### Install dotfiles

```
cd ~/.dotfiles && . ./bootstrap
```

## Credits

Influenced by and examples taken from:

- [mnarrell](https://github.com/mnarrell/dotfiles)
- [kwtucker](https://github.com/kwtucker/dotfiles)
- [caarlos0](https://github.com/caarlos0/dotfiles.fish) [LICENSE](license/LICENSE-CARLOSBECKER.md)
