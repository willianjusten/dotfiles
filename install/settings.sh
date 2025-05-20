#!/bin/sh

source colors.sh

# Cursor settings
if [ -f "$HOME/Library/Application\ Support/Cursor/User/settings.json" ]; then
  msg_update "cursor settings"
  rm $HOME/Library/Application\ Support/Cursor/User/settings.json
else
  msg_install "cursor settings"
fi
ln -sf $DOTFILES/settings/cursor/settings.json $HOME/Library/Application\ Support/Cursor/User/
msg_checking "cursor settings"

# .editorconfig
if [ -f "$HOME/.editorconfig" ]; then
  msg_update ".editorconfig"
  rm $HOME/.editorconfig
else
  msg_install ".editorconfig"
fi
ln -sf $DOTFILES/settings/.editorconfig $HOME/
msg_checking ".editorconfig"

# .gitconfig
if [ -f "$HOME/settings/git/.gitconfig" ]; then
  msg_update ".gitconfig"
  rm $HOME/.gitconfig
else
  msg_install ".gitconfig"
fi
ln -sf $DOTFILES/settings/git/.gitconfig $HOME/
msg_checking ".gitconfig"


# .gitignore
if [ -f "$HOME/settings/git/.gitignore" ]; then
  msg_update ".gitignore"
  rm $HOME/.gitignore
else
  msg_install ".gitignore"
fi
ln -sf $DOTFILES/settings/git/.gitignore $HOME/
msg_checking ".gitignore"

# .aliases
if [ -f "$HOME/.aliases" ]; then
  msg_update ".aliases"
  rm $HOME/.aliases
else
  msg_install ".aliases"
fi
ln -sf $DOTFILES/settings/.aliases $HOME/
msg_checking ".aliases"

# .npmrc
if [ -f "$HOME/.npmrc" ]; then
  msg_update ".npmrc"
  rm $HOME/.npmrc
else
  msg_install ".npmrc"
fi
ln -sf $DOTFILES/settings/.npmrc $HOME/
msg_checking ".npmrc"

# Ghostty config
if [ -f "$HOME/.config/ghostty" ]; then
  msg_update "ghostty config"
  rm $HOME/.config/ghostty
else
  msg_install "ghostty config"
  mkdir -p $HOME/.config/ghostty
fi
ln -sf $DOTFILES/settings/ghostty/config $HOME/.config/ghostty/
msg_checking "ghostty config"

# .zshrc
if [ -f "$HOME/.zshrc" ]; then
  msg_update ".zshrc"
  rm $HOME/.zshrc
else
  msg_install ".zshrc"
fi
ln -sf $DOTFILES/settings/.zshrc $HOME/
msg_checking ".zshrc"