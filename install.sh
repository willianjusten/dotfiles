#!/bin/bash

DOTFILES="$HOME/Developer/dotfiles"

if [[ -d $DOTFILES ]]; then
  echo 'Checking dotfiles directory'
else
  echo 'Cloning dotfiles'
  git clone https://github.com/willianjusten/dotfiles.git $DOTFILES
fi

cd $DOTFILES

source install/environment.sh
source install/softwares.sh
source install/settings.sh