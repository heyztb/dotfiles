# dotfiles

Personal macOS configuration managed with GNU Stow.

## Setup

```shell
brew install stow
./scripts/install.sh
```

Pass package names to install only part of the configuration:

```shell
./scripts/install.sh nvim helix yazi ghostty nushell
```

Existing files are backed up before linking to:

```text
~/.local/state/dotfiles/backups/<timestamp>/
```

Install the Tmux Plugin Manager separately:

```shell
./scripts/install-tpm.sh
```

## Helix themes

Melange light is the default. Use `:theme melange_light` or `:theme melange`
(dark) to switch for the current session. To change the default, use
`:config-open`, edit the top-level `theme`, save, and run `:config-reload`.
Both variants keep the terminal background.

Helix 25.07.1 requires manual switching. Newer builds supporting
[automatic theme selection](https://docs.helix-editor.com/master/themes.html)
can replace the top-level `theme = "melange_light"` with:

```toml
[theme]
light = "melange_light"
dark = "melange"
```

Automatic selection requires a terminal supporting mode 2031.

## Yazi previews

Local Melange flavors match the Helix dark/light palettes for code previews
and follow the terminal's reported appearance automatically. Restart Yazi after
installing the configuration. The flavors leave Yazi's UI defaults intact.
To force one palette, set both `dark` and `light` in
`packages/yazi/.config/yazi/theme.toml` to `melange-light` or `melange-dark`.

## Remove links

```shell
stow --dir="$PWD/packages" --target="$HOME" --no-folding --delete nvim tmux
```

## Local settings

Put machine- or work-specific Zsh settings in `~/.zprofile.local`. The tracked
profile sources it when present, while it remains outside this repository.
