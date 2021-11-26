## Getting started

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

Influneced by and examples taken from:

- [mnarrell](https://github.com/mnarrell/dotfiles)
- [kwtucker](https://github.com/kwtucker/dotfiles)
