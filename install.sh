#!/bin/bash

source colors.sh

DOTFILES="$HOME/development/dotfiles"

if [[ -d $DOTFILES ]]; then
    msg_checking 'Checking dotfiles directory'
else
    msg_install 'Cloning dotfiles'
    git clone https://github.com/willianjusten/dotfiles.git $DOTFILES
fi

cd $DOTFILES

source install/environment.sh

source install/softwares.sh

source config/global.sh
