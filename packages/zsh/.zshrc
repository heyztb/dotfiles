autoload -U compinit; compinit

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(sops completion zsh)"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "
alias ls='eza --no-filesize --long --color=always --icons=always --no-user'

export PATH="${HOME}/.local/bin:$PATH"

export EDITOR=nvim

. "$HOME/.deno/env"
