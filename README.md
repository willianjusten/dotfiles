# dotfiles

One source of truth for my Macs, applied with [chezmoi](https://chezmoi.io).

## Fresh Mac

1. Run:

   ```sh
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/willianjusten/dotfiles/main/install.sh)"
   ```

   It installs the Command Line Tools, Homebrew, chezmoi and 1Password, then pauses.
2. Open 1Password, sign in to both accounts, and turn on Settings > Developer >
   "Integrate with 1Password CLI" and "Use the SSH agent". Press Enter in the terminal
   to run `chezmoi init --apply` and answer its prompts (machine, git emails, 1Password).
3. Sign in to the App Store before the Brewfile reaches `mas` entries (or re-run `chezmoi apply`).
4. Finish the manual checklist below.

After the first apply, switch the repo remote to SSH to be able to push:
`git -C ~/Developer/dotfiles remote set-url origin git@github.com:willianjusten/dotfiles.git`

## Daily use

| Task | Command |
|---|---|
| Edit a managed file | `chezmoi edit ~/.zshrc` (or edit in `~`, then `chezmoi re-add`) |
| Preview changes | `chezmoi diff` |
| Apply | `chezmoi apply -v` |
| Pull and apply changes from the other Mac | `chezmoi update` |
| New app | Add it to `Brewfile` or `Brewfile.<machine>`, then `chezmoi apply` |
| Check app drift | `brew bundle check --file=Brewfile` |
| Monthly cleanup | `scripts/maintenance.sh` |
| Re-pin Node in Spoke repos after a volta bump | `scripts/spoke-mise-pins.sh` |

## What lives where

| Item | Owner |
|---|---|
| zsh, git, npm/yarn auth, mise, Ghostty, Cursor settings, SSH agent config | this repo |
| Secrets (npm token, Spoke workspace tokens, SSH key) | 1Password, read at apply time |
| Spoke repos and their agent setup | Spoke workspace (`make repos`, `make setup`), run by the clone script |
| Claude Code (`~/.claude`) | [agent-skills](https://github.com/willianjusten/agent-skills), run by a chezmoi script |
| Chrome, Microsoft To Do | their own account sync |
| Raycast | see [raycast/README.md](raycast/README.md) |

## 1Password items

| Reference | Account | Used by |
|---|---|---|
| `op://Personal/npm/token` | Personal | `~/.npmrc`, `~/.yarnrc.yml` |
| `op://Personal/GitHub SSH` (SSH key item) | Personal | SSH agent, git commit signing |
| `op://Employee/Spoke workspace env/{LINEAR_API_KEY,FIGMA_TOKEN,ASK_CIRCUIT_TOKEN}` | Spoke | `~/.spoke-env` |

Answering "no" to the 1Password prompt skips all of these (no tokens, no commit signing).

## Manual checklist

- System Settings > Spotlight > Search Privacy: add `~/Developer`, `~/.yarn`, `~/.npm`, `~/.cache`
- Static wallpaper (no Aerials)
- 1Password: Settings > Autofill > Set up macOS AutoFill; then untick "Passwords" in
  System Settings > General > AutoFill & Passwords (keep iCloud Keychain sync on)
- Chrome, per profile: 1Password extension, turn off Google Password Manager saving,
  Memory Saver on
- Spoke Chat: install from Spoke (not on Homebrew)
- Raycast: Cloud Sync or import `.rayconfig`
- Log in to `gh`, `gcloud` (`gcloud auth login`, `gcloud auth application-default login`),
  `flyctl`, `stripe`, `ngrok`, OrbStack
- Reboot once so the maxfiles limit applies to every app

## Verify

```sh
time zsh -i -c exit             # under 0.15 s
launchctl limit maxfiles        # 65536 524288
chezmoi diff                    # empty
cd ~/Developer/spoke/web-apps && node -v   # matches package.json volta.node
git -C ~/Developer/spoke/web-apps config user.email
```

## Committing

The repo is public. `.githooks/pre-commit` runs gitleaks on staged changes, and the
first `chezmoi apply` sets `core.hooksPath` for it. Secrets only ever appear as
`onepasswordRead` calls in `*.tmpl` files.
