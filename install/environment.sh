#!/bin/sh

source colors.sh

# Brew
msg_install "Setting up Homebrew"
if test ! $(which brew); then
  msg_install "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  msg_ok 'Homebrew installed'
  exec "$SHELL"
else
  msg_alert "Homebrew already installed"
fi

msg_update "Updating Homebrew"
brew update
brew upgrade

# Brew apps
msg_install "Installing apps with brew"
brew cleanup
brew tap buo/cask-upgrade
brew install \
  asdf \
  bat \
  curl \
  gh \
  git \
  httpie \
  tree \
  wget \
  zsh
msg_ok "Apps installed"

# oh-my-zsh
if (test ! -d $HOME/.oh-my-zsh); then
  msg_install "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Install plugins
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  msg_ok "oh-my-zsh installed"
else
  msg_alert "oh-my-zsh already installed"
fi


# Node.js with asdf
if (test ! -d $HOME/.asdf/shims/node); then
  msg_install "Installing Node.js"
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs latest
  asdf set -u nodejs latest
  msg_ok "Node.js installed"
else
  msg_alert "Node.js already installed"
fi
