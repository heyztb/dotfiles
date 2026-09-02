# dotfiles

Personal macOS configuration managed with GNU Stow.

## Setup

```shell
brew install stow
./scripts/install.sh
```

Pass package names to install only part of the configuration:

```shell
./scripts/install.sh nvim ghostty nushell
```

Existing files are backed up before linking to:

```text
~/.local/state/dotfiles/backups/<timestamp>/
```

Install the Tmux Plugin Manager separately:

```shell
./scripts/install-tpm.sh
```

## Remove links

```shell
stow --dir="$PWD/packages" --target="$HOME" --no-folding --delete nvim tmux
```

## Local settings

Put machine- or work-specific Zsh settings in `~/.zprofile.local`. The tracked
profile sources it when present, while it remains outside this repository.
