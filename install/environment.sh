#!/bin/sh

source colors.sh

# Brew ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
msg_install "Setting up Homebrew"
if test ! $(which brew); then
  msg_install "Installing homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  msg_ok 'Homebrew'
else
  msg_alert "Homebrew already instaled"
  msg_update "Updating Homebrew"
  brew update
fi

# Brew apps :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
msg_install "Installing apps with brew"
brew=(
  "rbenv"
  "git"
  "hub"
)

msg_install "Setting up pip and awscli"
sudo easy_install pip
pip install awscli --upgrade --user

# NVM :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
msg_install "Installing NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
msg_ok "NVM Installed"
