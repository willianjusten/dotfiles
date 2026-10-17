# dotfiles

One source of truth for my Macs, applied with [chezmoi](https://chezmoi.io).

## Set up a Mac

Works on a new Mac and on one that already has config, repos and credentials.

1. Put the secrets listed under [1Password items](#1password-items) in 1Password first:
   chezmoi replaces `~/.npmrc`, `~/.yarnrc.yml` and `~/.spoke-env` with their values.
2. Run:

   ```sh
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/willianjusten/dotfiles/main/install.sh)"
   ```

   It installs Homebrew (with the Command Line Tools), chezmoi and 1Password if missing, then pauses.
3. Open 1Password, sign in to the Spoke account, and turn on Settings > Developer >
   "Integrate with 1Password CLI". Press Enter to run `chezmoi init` and answer its
   prompts (machine, git emails, 1Password).
4. `scripts/backup.sh` then copies every file chezmoi will replace or remove to
   `~/.dotfiles-backup/<timestamp>/`, with a `changes.diff` of what changes in each
   (secrets masked). Review it, press Enter to apply, and later move anything you
   want to keep from the backup into the dotfiles.
5. Sign in to the App Store, then install the App Store apps:
   `brew bundle --file=~/Developer/dotfiles/Brewfile.mas`
6. On a Mac that had the old setup, open a new shell and run `scripts/cleanup.sh`.
   It removes nvm, asdf, rbenv and Volta (once mise provides Node), rebuildable
   caches, and unused apps and Homebrew packages, asking before each group and
   showing how much space it frees. Docker volumes and personal files are never touched.
7. Finish the manual checklist below.

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
| zsh, git, npm/yarn auth, mise, Ghostty, Cursor settings | this repo |
| Secrets (npm token, Spoke workspace tokens) | 1Password, read at apply time |
| SSH keys and `~/.ssh/config` | the machine itself, not managed |
| Spoke repos and their agent setup | Spoke workspace (see its README); chezmoi only adds mise Node pins |
| Claude Code (`~/.claude`) | [agent-skills](https://github.com/willianjusten/agent-skills), run by a chezmoi script |
| Chrome, Microsoft To Do | their own account sync |
| Raycast | see [raycast/README.md](raycast/README.md) |

## 1Password items

| Reference | Account | Used by |
|---|---|---|
| `op://Employee/Spoke workspace env/NPM_TOKEN` | Spoke | `~/.npmrc`, `~/.yarnrc.yml` |
| `op://Employee/Spoke workspace env/{LINEAR_API_KEY,FIGMA_TOKEN,ASK_CIRCUIT_TOKEN}` | Spoke | `~/.spoke-env` |

Answering "no" to the 1Password prompt leaves these three files untouched.

## Manual checklist

- System Settings > Spotlight > Search Privacy: add `~/Developer`, `~/.yarn`, `~/.npm`, `~/.cache`
- Static wallpaper (no Aerials); then remove the downloaded Aerial videos in Settings > Wallpaper
- Login items and background agents (System Settings > General > Login Items): remove
  Loom, Unsplash Wallpapers and Logi RightSight (without a Logi camera); turn off Adobe's
  `ccxprocess` if Lightroom is occasional; turn off unused Spoken Content / Siri voices
- Docker Desktop to OrbStack (keep Docker Desktop until the tests pass;
  `docker context use desktop-linux` switches back):
  1. Dump any local DB data you need (`docker volume ls`)
  2. `brew install --cask orbstack`, start it and approve its admin prompt
     (it repoints `/var/run/docker.sock`, which testcontainers uses)
  3. In `~/.docker/config.json`, change `"credsStore": "desktop"` to `"osxkeychain"`
     and keep the `credHelpers` gcloud entry: `docker-credential-desktop` goes away with Docker Desktop
  4. `gcloud auth login` and `gcloud auth configure-docker europe-west2-docker.pkg.dev`
     (the Firebase emulator image is private)
  5. In backend-services, run one integration suite per container type: the Firebase
     emulator (`@getcircuit/firestore-test`), Postgres (engine) and Elasticsearch + Redis (indexer)
  6. Uninstall Docker Desktop (removes `Docker.raw`)
- Network: add a secondary DNS (1.0.0.1 or 8.8.8.8)
- Lightroom: purge the Camera Raw and Lightroom caches in its preferences
- `~/Downloads`: move ID scans and bank statements into 1Password; keep the Emergency Kit offline
- 1Password: Settings > Autofill > Set up macOS AutoFill; then untick "Passwords" in
  System Settings > General > AutoFill & Passwords (keep iCloud Keychain sync on)
- Chrome, per profile: 1Password extension, turn off Google Password Manager saving,
  Memory Saver on; delete unused profiles only after exporting their passwords
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
