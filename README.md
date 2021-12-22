## Recommended Software

For both Linux and macOS:

- [`starship.rs`](https://starship.rs) the shell we are using;
- [`bat`](https://github.com/sharkdp/bat) a `cat` with wings;

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

#### Customizations

`fish` plugins are managed by `fisher` and can be cloned directly into `~/.extra/plugins` or added directly to a new file `~/.extra/plugins/fish_plugins`

```bash
jorgebucaran/fisher
jorgebucaran/nvm.fish
jorgebucaran/replay.fish
```

Add custom functions to `~/.extra/functions`

## ZSH

This is really not maintained. I have been transitioning over to fish shell and while doing so have started to restructure dotfiles thus making the zsh install untested. Use at your own risk.

### Getting started

<!-- ```bash
sh -c "$(curl -fsSL https://gitlab.com/dantuck/dotfiles/-/raw/main/utils/install.sh)"
``` -->

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
- [caarlos0](https://github.com/caarlos0/dotfiles.fish) ([LICENSE](license/LICENSE-CARLOSBECKER.md))
