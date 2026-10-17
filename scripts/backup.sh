#!/bin/bash
# Run between `chezmoi init` and `chezmoi apply` on a machine that already has config.
# Copies every file chezmoi would replace or remove into ~/.dotfiles-backup/<timestamp>/ and
# writes changes.diff (current vs dotfiles, secrets masked) so you can decide what
# to bring back into the dotfiles afterwards.
set -euo pipefail

backup_root="$HOME/.dotfiles-backup"
backup_dir="$backup_root/$(date +%Y%m%d-%H%M%S)"
report="$backup_dir/changes.diff"
mkdir -p "$backup_dir"
chmod 700 "$backup_root" "$backup_dir"

mask_secrets() {
  sed -E 's/((_authToken|[A-Za-z_]*[Tt][Oo][Kk][Ee][Nn]|[A-Z_]*KEY|[A-Z_]*SECRET|[A-Z_]*PASSWORD)[^=:]*[=:] *).+/\1<masked>/'
}

rendered="$backup_dir/.rendered"
trap 'rm -f "$rendered"' EXIT
changed_files=()
while IFS= read -r target; do
  # New files replace nothing, so there is nothing to back up
  [ -f "$target" ] || continue
  relative_path="${target#"$HOME"/}"
  if ! chezmoi cat "$target" > "$rendered"; then
    echo "Could not build ~/$relative_path (often a missing 1Password item, see the error above)." >&2
    echo "Nothing was backed up or applied. Fix it and run install.sh again." >&2
    rm -rf "$backup_dir"
    exit 1
  fi
  if cmp -s "$target" "$rendered"; then
    continue
  fi
  mkdir -p "$backup_dir/$(dirname "$relative_path")"
  cp -p "$target" "$backup_dir/$relative_path"
  diff -u --label "current ~/$relative_path" --label "dotfiles ~/$relative_path" "$target" "$rendered" | mask_secrets >> "$report" || true
  changed_files+=("~/$relative_path")
done < <(chezmoi managed --include files --exclude externals --path-style absolute)

# Files listed in .chezmoiremove are deleted on apply
while IFS= read -r relative_path; do
  case "$relative_path" in "" | "#"*) continue ;; esac
  [ -f "$HOME/$relative_path" ] || continue
  mkdir -p "$backup_dir/$(dirname "$relative_path")"
  cp -p "$HOME/$relative_path" "$backup_dir/$relative_path"
  diff -u --label "current ~/$relative_path" --label "removed by dotfiles" "$HOME/$relative_path" /dev/null | mask_secrets >> "$report" || true
  changed_files+=("~/$relative_path (removed)")
done < "$(chezmoi source-path)/.chezmoiremove"

if [ ${#changed_files[@]} -eq 0 ]; then
  echo "chezmoi replaces no existing file; nothing backed up"
  rm -f "$rendered"
  rmdir "$backup_dir"
  exit 0
fi

echo "Backed up ${#changed_files[@]} file(s) that chezmoi will replace or remove, to $backup_dir:"
printf '  %s\n' "${changed_files[@]}"
echo "What changes in each (lines starting with - exist only in your current file):"
echo "  less $report"
