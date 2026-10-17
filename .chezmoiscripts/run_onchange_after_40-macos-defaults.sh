#!/bin/bash
# Values captured from the Mac Studio on 2026-10-17. Re-runs whenever this file changes.
set -euo pipefail

defaults write NSGlobalDomain AppleInterfaceStyle -string Dark
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 47
defaults write com.apple.dock show-recents -bool false

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXPreferredViewStyle -string icnv
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# No .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

killall Dock Finder 2>/dev/null || true

sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
