#!/bin/bash
# Monthly cleanup of rebuildable caches. Never removes Docker volumes (local DB data).
set -uo pipefail

brew update && brew upgrade && brew cleanup --prune=all
mise upgrade && mise prune --yes

yarn cache clean --all
npm cache clean --force
if command -v pnpm >/dev/null 2>&1; then
  pnpm store prune
fi

if docker info >/dev/null 2>&1; then
  docker system prune --force
fi

echo "Optional: npx npkill --directory ~/Developer/github to drop stale node_modules"
