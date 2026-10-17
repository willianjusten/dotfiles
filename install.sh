#!/bin/bash
# Bootstrap a Mac, new or already set up: Homebrew (installs the Command Line Tools)
# -> 1Password -> chezmoi init -> backup of files chezmoi will replace -> chezmoi apply.
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/willianjusten/dotfiles/main/install.sh)"
# Extra arguments go to `chezmoi init`, e.g. --promptChoice machine=macbook
set -euo pipefail

DOTFILES="$HOME/Developer/dotfiles"

if [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install chezmoi
# Skip what is already installed outside Homebrew, which brew would refuse to overwrite
[ -d /Applications/1Password.app ] || brew install --cask 1password
command -v op >/dev/null 2>&1 || brew install --cask 1password-cli

if [ -t 0 ]; then
  cat <<'EOF'

Before continuing (skip if you will answer "no" to the 1Password prompt):
  1. Open 1Password and sign in to the Spoke account
  2. Settings > Developer: turn on "Integrate with 1Password CLI"

EOF
  read -r -p "Press Enter to run chezmoi init "
fi

chezmoi init --source "$DOTFILES" "$@" willianjusten
"$DOTFILES/scripts/backup.sh"

if [ -t 0 ]; then
  read -r -p "Press Enter to apply (Ctrl+C to stop and review first) "
fi
chezmoi apply -v
