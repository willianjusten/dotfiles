#!/bin/bash
# One-time cleanup of a Mac that had the old setup. Run it after `chezmoi apply`.
# Each group lists what it removes and how much space that frees, then asks.
# Only rebuildable caches and tools the dotfiles replaced are touched: Docker
# volumes, ~/Pictures and the audit's other "decide" items are left alone.
set -uo pipefail
eval "$(/opt/homebrew/bin/brew shellenv)"

backup_dir="$HOME/.dotfiles-backup/cleanup-$(date +%Y%m%d-%H%M%S)"
total_freed_kb=0

size_kb() {
  du -sk "$@" 2>/dev/null | awk '{ sum += $1 } END { print sum + 0 }'
}

human_size() {
  awk -v kb="$1" 'BEGIN { if (kb >= 1048576) printf "%.1f GB", kb / 1048576; else printf "%.0f MB", kb / 1024 }'
}

confirm() {
  local answer
  read -r -p "$1 [y/N] " answer < /dev/tty
  [ "$answer" = y ] || [ "$answer" = Y ]
}

app_running() {
  pgrep -xq "$1"
}

# Prints the given paths that exist, one per line
existing_paths() {
  local path
  for path in "$@"; do
    [ -e "$path" ] && echo "$path"
  done
}

# Prints the given Homebrew formulae or casks that are installed
installed_packages() {
  local kind="$1" package
  shift
  for package in "$@"; do
    brew list "--$kind" "$package" >/dev/null 2>&1 && echo "$package"
  done
}

# Lists paths with their size, asks, deletes them and adds to the total
offer_removal() {
  local title="$1"
  shift
  local paths=()
  while IFS= read -r path; do paths+=("$path"); done < <(existing_paths "$@")
  [ ${#paths[@]} -eq 0 ] && return 0

  local kb
  kb=$(size_kb "${paths[@]}")
  echo
  echo "$title ($(human_size "$kb")):"
  printf '  %s\n' "${paths[@]}"
  if confirm "Delete these?"; then
    rm -rf "${paths[@]}"
    total_freed_kb=$((total_freed_kb + kb))
  fi
}

echo "== 1. Runtime managers replaced by mise"
if ! mise which node >/dev/null 2>&1; then
  echo "Skipping: mise has no Node yet. Apply the dotfiles and open a new shell first."
else
  echo "mise provides Node $(mise exec -- node -v), so nvm, asdf, rbenv and Volta can go."

  old_formulae=()
  while IFS= read -r formula; do old_formulae+=("$formula"); done < <(installed_packages formula nvm asdf rbenv)
  if [ ${#old_formulae[@]} -gt 0 ] && confirm "brew uninstall ${old_formulae[*]}?"; then
    brew uninstall "${old_formulae[@]}"
  fi

  offer_removal "Old runtime folders" "$HOME/.volta" "$HOME/.asdf" "$HOME/.rbenv" "$HOME/.nvm"

  # Volta PATH lines that the old setup added outside the files chezmoi manages
  for startup_file in "$HOME/.zshenv" "$HOME/.profile"; do
    grep -q VOLTA "$startup_file" 2>/dev/null || continue
    echo
    echo "Volta lines in ~/${startup_file##*/}:"
    grep -n VOLTA "$startup_file" | sed 's/^/  /'
    if confirm "Remove them (a copy goes to $backup_dir)?"; then
      mkdir -p "$backup_dir"
      cp -p "$startup_file" "$backup_dir/"
      sed -i '' '/VOLTA/d' "$startup_file"
      # Drop the file when only blank lines are left
      grep -q '[^[:space:]]' "$startup_file" || rm "$startup_file"
    fi
  done
fi

echo
echo "== 2. Rebuildable caches (re-downloaded when needed)"
offer_removal "Package manager caches" \
  "$HOME/.yarn/berry/cache" "$HOME/.yarn/berry/metadata" "$HOME/.npm/_cacache" "$HOME/Library/pnpm/store" \
  "$HOME/.cache/puppeteer" "$HOME/Library/Caches/pip" "$HOME/Library/Caches/node-gyp" \
  "$HOME/.cache/sloppy" "$HOME/.cache/uv" "$HOME/.cache/huggingface" "$HOME/.cache/prisma"
offer_removal "App leftovers" \
  "$HOME/Library/Caches/loom-updater" "$HOME/Library/Application Support/com.docker.install/in_progress"

if app_running Cursor; then
  echo; echo "Skipping Cursor caches: quit Cursor and re-run to clear them."
else
  cursor_dir="$HOME/Library/Application Support/Cursor"
  offer_removal "Cursor caches" "$cursor_dir/CachedData" "$cursor_dir/Cache" "$cursor_dir/logs"
fi

if app_running "Google Chrome"; then
  echo; echo "Skipping Chrome cache: quit Chrome and re-run to clear it."
else
  offer_removal "Chrome disk cache" "$HOME/Library/Caches/Google/Chrome"
fi

homebrew_cache_kb=$(size_kb "$(brew --cache)")
echo
if [ "$homebrew_cache_kb" -gt 0 ] && confirm "brew cleanup --prune=all (cache is $(human_size "$homebrew_cache_kb"), plus old versions)?"; then
  brew cleanup --prune=all
  total_freed_kb=$((total_freed_kb + homebrew_cache_kb))
fi

echo
echo "== 3. Apps and Homebrew packages no longer used"
unused_casks=()
while IFS= read -r cask; do unused_casks+=("$cask"); done < <(installed_packages cask zoom iterm2 visual-studio-code ghostty beekeeper-studio)
if [ ${#unused_casks[@]} -gt 0 ] && confirm "brew uninstall --cask --zap ${unused_casks[*]} (also removes their settings and launch agents)?"; then
  brew uninstall --cask --zap --force "${unused_casks[@]}"
fi

unused_formulae=()
while IFS= read -r formula; do unused_formulae+=("$formula"); done < <(installed_packages formula nginx unbound python@3.11 mtr nano direnv)
if [ ${#unused_formulae[@]} -gt 0 ] && confirm "brew uninstall ${unused_formulae[*]}?"; then
  # Without --ignore-dependencies brew refuses any formula something else still needs
  for formula in "${unused_formulae[@]}"; do
    brew uninstall "$formula" || echo "Kept $formula: another formula depends on it"
  done
fi

if brew tap | grep -qx bastionzero/tap && confirm "brew untap bastionzero/tap?"; then
  brew untap bastionzero/tap
fi

if [ -d /Applications/Firefox.app ]; then
  echo
  echo "Firefox: passwords saved there are lost on uninstall. Check about:logins and"
  echo "export anything into 1Password first."
  if app_running firefox; then
    echo "Skipping: quit Firefox and re-run to remove it."
  else
    offer_removal "Firefox and its data" "/Applications/Firefox.app" \
      "$HOME/Library/Caches/Firefox" "$HOME/Library/Caches/Mozilla" \
      "$HOME/Library/Application Support/Firefox" "$HOME/Library/Preferences/org.mozilla.firefox.plist"
  fi
fi

echo
echo "Freed about $(human_size "$total_freed_kb") (not counting brew uninstalls)."
echo "Optional: npx npkill --directory ~/Developer/github to drop stale node_modules."
echo "The rest (login items, Spotlight, Docker, wallpaper, Chrome profiles) is in the README checklist."
