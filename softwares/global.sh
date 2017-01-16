# cask
brew install caskroom/cask/brew-cask

# add formulae to homebrew
brew tap homebrew/science # science
brew tap caskroom/fonts # fonts
brew tap caskroom/versions

# langs
brew install python # python

# remove outdated versions from the cellar
brew cleanup

# browsers
brew cask install firefox 2> /dev/null
brew cask install google-chrome 2> /dev/null

# dev apps
brew cask install imageoptim 2> /dev/null
brew cask install iterm2 2> /dev/null
brew cask install sublime-text3 2> /dev/null

# apps
brew cask install vlc 2> /dev/null
brew cask install transmission 2> /dev/null
brew cask install spotify 2> /dev/null
brew cask install slack 2> /dev/null
brew cask install franz 2> /dev/null
brew cask install coconutbattery 2> /dev/null
