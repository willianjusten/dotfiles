#!/bin/bash
# Fresh-Mac bootstrap: Xcode CLT -> Homebrew -> 1Password -> chezmoi init --apply.
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/willianjusten/dotfiles/main/install.sh)"
set -euo pipefail

DOTFILES="$HOME/Developer/dotfiles"

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  read -r -p "Finish the Command Line Tools install, then press Enter "
fi

if [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install chezmoi
brew install --cask 1password 1password-cli

cat <<'EOF'

Before continuing (skip if you will answer "no" to the 1Password prompt):
  1. Open 1Password and sign in to both accounts
  2. Settings > Developer: turn on "Integrate with 1Password CLI" and "Use the SSH agent"

EOF
read -r -p "Press Enter to run chezmoi "

chezmoi init --source "$DOTFILES" --apply willianjusten
