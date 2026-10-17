#!/bin/bash
# Fresh-Mac bootstrap: Homebrew (installs the Command Line Tools) -> 1Password -> chezmoi init --apply.
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/willianjusten/dotfiles/main/install.sh)"
# Extra arguments go to `chezmoi init`, e.g. --promptChoice machine=macbook
set -euo pipefail

DOTFILES="$HOME/Developer/dotfiles"

if [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install chezmoi
brew install --cask 1password 1password-cli

if [ -t 0 ]; then
  cat <<'EOF'

Before continuing (skip if you will answer "no" to the 1Password prompt):
  1. Open 1Password and sign in to both accounts
  2. Settings > Developer: turn on "Integrate with 1Password CLI" and "Use the SSH agent"

EOF
  read -r -p "Press Enter to run chezmoi "
fi

chezmoi init --source "$DOTFILES" --apply "$@" willianjusten
