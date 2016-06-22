source common/functions.sh

# homebrew
if which brew &> /dev/null; then
    msg_checking "homebrew"
else
    msg_install "Homebrew" "ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ok "OK"
fi

# node
if which node &> /dev/null; then
    msg_checking "node"
else
    msg_install "Node" "brew install node"
    brew install node
    ok "OK"
fi

# phantomjs
if which phantomjs &> /dev/null; then
    msg_checking "phantomjs"
else
    msg_install "phantomjs" "brew install phantomjs"
    brew install phantomjs
    msg_ok "OK"
fi

# mongo
if which mongod &> /dev/null; then
    msg_checking "mongodb"
else
    msg_install "mongodb" "brew install mongodb"
    brew install mongodb --with-openssl
    msg_ok "OK"
fi
