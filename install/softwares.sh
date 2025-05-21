#!/bin/sh

source colors.sh

#  Brew Cask ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
msg_install "Installing apps with brew cask"

cask=(
  "cursor"
  "discord"
  "ghostty"
  "google-chrome"
  "handbrake"
  "raycast"
  "transmission"
  "visual-studio-code"
  "imageOptim"
  "capcut"
  "yaak"
)

for app in "${cask[@]}"; do
  msg_install "Installing $app"
  brew install --cask $app
  msg_ok "$app installed"
done
