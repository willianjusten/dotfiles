# Path
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/lib:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

# Fix lint-staged spinners and colors
export FORCE_COLOR=1

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path sourses
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

# Zsh plugins
plugins=(
  git 
  zsh-syntax-highlighting 
  zsh-autosuggestions
)

# Zsh history settings
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000

setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY

# ASDF
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# append completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
