#!/bin/sh

source colors.sh

# .bash_profile ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [ -f "$HOME/.bash_profile" ]; then
    msg_update ".bash_profile"
    rm ~/.bash_profile
else
    msg_install ".bash_profile"
fi

sudo ln -s $DOTFILES/config/.bash_profile ~/.bash_profile
msg_checking ".bash_profile"

# .bash_prompt ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [ -f "$HOME/.bash_prompt" ]; then
    msg_update ".bash_prompt"
    rm ~/.bash_prompt
else
    msg_install ".bash_prompt"
fi

sudo ln -s $DOTFILES/config/.bash_prompt ~/.bash_prompt
msg_checking ".bash_prompt"

# .aliases ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [ -f "$HOME/.aliases" ]; then
    msg_update ".aliases"
    rm ~/.aliases
else
    msg_install ".aliases"
fi

sudo ln -s $DOTFILES/config/.aliases ~/.aliases
msg_checking ".aliases"

# .gitconfig ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [ -f "$HOME/.gitconfig" ]; then
    msg_update ".gitconfig"
    rm ~/.gitconfig
else
    msg_install ".gitconfig"
fi

sudo ln -s $DOTFILES/config/.gitconfig ~/.gitconfig
msg_checking ".gitconfig"

# .bashrc ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [ -f "$HOME/.bashrc" ]; then

    msg_update ".bashrc"

    if ! grep -inr ".bash_profile" ~/.bashrc > /dev/null; then
        echo 'source ~/.bash_profile' >> ~/.bashrc
        source ~/.bashrc
        msg_checking ".bashrc"
        msg_alert "For use on this session, type: source ~/.bashrc"
    fi
fi
