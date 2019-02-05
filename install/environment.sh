#!/bin/sh

# Setup Brew (https://brew.sh/) and Brew Cask (http://caskroom.io/) apps ::::::::::::::::::::::::::::::::::::::::::::::

# Brew ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo "Setting up Homebrew"
if test ! $(which brew); then
  echo "Installing homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already instaled"
  echo "Updating Homebrew"
  brew update
fi

# Brew apps :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo "Installing apps with brew"
brew=(
  "rbenv"
  "nvm"
  "git"
  "hub"
)

echo "Setting up pip and awscli"
sudo easy_install pip
pip install awscli --upgrade --user
