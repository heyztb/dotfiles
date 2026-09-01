# dotfiles

Personal macOS configuration for Neovim, Tmux, Hunk, Ghostty, Nushell, and Zsh, managed as GNU Stow packages.

## Install

Install GNU Stow if needed:

```sh
brew install stow
```

Install every package:

```sh
./scripts/install.sh
```

Or install only selected packages:

```sh
./scripts/install.sh nvim ghostty nushell
```

The installer uses per-file links (`--no-folding`) so applications can keep runtime files next to managed configuration. Existing conflicting files are moved, never overwritten, beneath:

```text
~/.local/state/dotfiles/backups/<timestamp>/
```

If `XDG_STATE_HOME` is set, backups use that directory instead of `~/.local/state`.

## Packages

| Package | Installed location |
| --- | --- |
| `nvim` | `~/.config/nvim` |
| `tmux` | `~/.config/tmux` |
| `hunk` | `~/.config/hunk/config.toml` |
| `ghostty` | `~/.config/ghostty` |
| `nushell` | `~/Library/Application Support/nushell` |
| `zsh` | `~/.zshenv`, `~/.zprofile`, and `~/.zshrc` |

Install the Tmux Plugin Manager separately. The helper is safe to run more than once:

```sh
./scripts/install-tpm.sh
```

Then start Tmux and press `prefix` + <kbd>I</kbd> to install configured plugins.

## Uninstall links

Remove links for selected packages without deleting repository files:

```sh
stow --dir="$PWD/packages" --target="$HOME" --no-folding --delete nvim tmux
```

Use the absolute repository path instead of `$PWD` when running the command outside this checkout.

## Restoring a backup

1. Remove the relevant Stow package with `stow --delete` as shown above.
2. Locate the timestamped backup beneath `~/.local/state/dotfiles/backups` (or `$XDG_STATE_HOME/dotfiles/backups`).
3. Move the backed-up file to its original home-relative path.

Backups are intentionally retained until they are manually reviewed and removed.

## Intentionally unmanaged files

Generated data and machine state stay outside this repository:

- Git and Jujutsu metadata from the former per-application repositories
- Neovim logs, caches, downloaded plugins, and editor state
- Hunk `state.json`
- Nushell history and generated Atuin/Zoxide integration
- Zsh history and session data
- Tmux plugin checkouts under `~/.tmux/plugins`

Before publishing this repository, review machine- and work-specific values (including `GOPRIVATE`), run a secret scan, and refresh GitHub CLI authentication. The former application repositories should remain untouched until the consolidated repository has been published and verified.
