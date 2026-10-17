#!/bin/bash
# Bootstrap a Mac, new or already set up: Homebrew (installs the Command Line Tools)
# -> 1Password -> chezmoi init -> backup of files chezmoi will replace -> chezmoi apply.
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/willianjusten/dotfiles/main/install.sh)"
# Extra arguments go to `chezmoi init`, e.g. --promptString 'Personal git email=me@example.com'
# (chezmoi matches these flags by prompt text, not by data key)
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
  read -r -p "Press Enter to continue "
fi

# Ask the chezmoi init questions here and pass the answers as flags: chezmoi's own
# prompts skipped input in Ghostty. The prompt texts must match .chezmoi.toml.tmpl.
# Once chezmoi.toml exists, the *Once prompts reuse its values and nothing is asked.
init_answers=()
if [ -t 0 ] && [ ! -f "$HOME/.config/chezmoi/chezmoi.toml" ]; then
  echo "Which Mac is this?"
  select machine in studio macbook; do
    [ -n "$machine" ] && break
  done
  read -r -p "Personal git email: " personal_email
  read -r -p "Spoke git email: " work_email
  read -r -p "Read secrets from 1Password (app signed in with CLI integration on)? [Y/n] " use_1password
  case "$use_1password" in [nN]*) use_1password=false ;; *) use_1password=true ;; esac
  init_answers=(
    --promptChoice "Which Mac is this=$machine"
    --promptString "Personal git email=$personal_email"
    --promptString "Spoke git email=$work_email"
    --promptBool "Read secrets from 1Password (app signed in with CLI integration on)=$use_1password"
    --promptString "Spoke 1Password sign-in address=spokedelivery.1password.com"
  )
fi

chezmoi init --source "$DOTFILES" ${init_answers[@]+"${init_answers[@]}"} "$@" willianjusten
"$DOTFILES/scripts/backup.sh"

if [ -t 0 ]; then
  # A typed word, not Enter, so a stray newline left in the terminal can't start the apply
  apply_answer=""
  while [ "$apply_answer" != "apply" ]; do
    read -r -p "Review the backup above, then type 'apply' to continue (Ctrl+C to stop): " apply_answer
  done
fi
# No pager: brew and the sudo steps prompt for a password, and less would take the keystrokes
chezmoi apply -v --no-pager
