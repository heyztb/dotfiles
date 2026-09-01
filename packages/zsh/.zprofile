export GOPATH=~/go
export GOPRIVATE='github.com/Joingo'
# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH=$PATH:$GOPATH/bin
alias work='cd ~/Code/Work/'
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

. "$HOME/.atuin/bin/env"
