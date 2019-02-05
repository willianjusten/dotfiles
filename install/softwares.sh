#!/bin/sh

#  Brew Cask ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo "Installing apps with brew cask"
brew cask

cask=(
  "google-chrome"
  "firefox"
  "iterm2"
  "visual-studio-code"
  "psequel"
  "transmission"
  "stremio"
  "spotify"
  "coconutbattery"
  "zoomus"
  "handbrake"
)

for app in "${cask[@]}"; do
  echo "Installing $app"
  brew cask install $app
done
