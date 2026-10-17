#!/bin/bash
# agent-skills owns Claude Code config (~/.claude); chezmoi only runs its installer.
# Later updates: ~/Developer/agent-skills/install.sh --update
set -euo pipefail

agent_skills="$HOME/Developer/agent-skills"
if [ ! -d "$agent_skills" ]; then
  git clone git@github.com:willianjusten/agent-skills.git "$agent_skills"
fi
"$agent_skills/install.sh"
