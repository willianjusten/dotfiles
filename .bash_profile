export PATH=${PATH}:/Users/will/Development/eclipse:/Users/will/Development/sdk/platform-tools:/Users/will/Development/sdk/tools

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# programs
alias subl='open -a "Sublime Text"'
# also/or do this:
# ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{path,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;


# Rbenv for Ruby Environment
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Virtualenvwrapper and Python
PATH=/usr/local/Cellar/python/2.7.6_1/bin:$PATH
export PATH
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
