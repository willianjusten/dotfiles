#!/bin/bash
# Writes a gitignored mise.local.toml in each Spoke repo from its package.json
# "volta" pins, since mise does not read that field. Re-run after a volta bump.
set -euo pipefail

workspace="${1:-$HOME/Developer/spoke}"

for package_json in "$workspace"/*/package.json; do
  repo_dir="$(dirname "$package_json")"
  node_version="$(plutil -extract volta.node raw -o - "$package_json" 2>/dev/null)" || continue
  yarn_version="$(plutil -extract volta.yarn raw -o - "$package_json" 2>/dev/null)" || yarn_version=""

  {
    echo "# Generated from package.json volta pins by dotfiles/scripts/spoke-mise-pins.sh"
    echo "[tools]"
    echo "node = \"$node_version\""
    if [ -n "$yarn_version" ]; then
      echo "yarn = \"$yarn_version\""
    fi
  } > "$repo_dir/mise.local.toml"

  echo "$(basename "$repo_dir"): node $node_version${yarn_version:+, yarn $yarn_version}"
  (cd "$repo_dir" && mise install --quiet)
done
