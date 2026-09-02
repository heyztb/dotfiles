export GOPATH=~/go

[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH=$PATH:$GOPATH/bin
export CARGO_NET_GIT_FETCH_WITH_CLI=true

. "$HOME/.atuin/bin/env"
