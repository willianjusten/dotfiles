# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# programs
#alias subl='open -a "Sublime Text"'
# also/or do this:
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{path,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;