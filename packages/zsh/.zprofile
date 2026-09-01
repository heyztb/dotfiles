export GOPATH=~/go
export GOPRIVATE='github.com/Joingo'
# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH=$PATH:$GOPATH/bin
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export PATH="~/.avm/bin:$PATH"
export PATH="~/.composer/vendor/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
alias work='cd ~/Code/Work/'
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

. "$HOME/.atuin/bin/env"
