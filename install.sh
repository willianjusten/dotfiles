#!/bin/bash

source colors.sh

DOTFILES="$HOME/Developer/dotfiles"

if [[ -d $DOTFILES ]]; then
    print 'Checking dotfiles directory'
else
    print 'Cloning dotfiles'
    git clone https://github.com/willianjusten/dotfiles.git $DOTFILES
fi

cd $DOTFILES

source install/environment.sh

source install/softwares.sh

source install/settings.sh
