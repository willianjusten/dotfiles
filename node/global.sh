source common/functions.sh

# nodejs
if which node &> /dev/null; then
    msg_checking "node"
else
    msg_install "node" "npm install -g n"
    npm install -g n
    sudo n stable
    echo "OK"
fi

# yeoman
if which yo &> /dev/null; then
    msg_checking "yo"
else
    msg_install "yo" "npm install -g yo"
    npm install -g yo
    echo "OK"
fi

# grunt-cli
if which grunt &> /dev/null; then
    msg_checking "grunt"
else
    msg_install "grunt" "npm install -g grunt-cli"
    npm install -g grunt-cli
    echo "OK"
fi

# gulp
if which gulp &> /dev/null; then
    msg_checking "gulp"
else
    msg_install "gulp" "npm install -g gulp"
    npm install -g gulp
    echo "OK"
fi

# stylus
if which stylus &> /dev/null; then
    msg_checking "stylus"
else
    msg_install "stylus" "npm install -g stylus"
    npm install -g stylus
    echo "OK"
fi

# browserify
if which browserify &> /dev/null; then
    msg_checking "browserify"
else
    msg_install "browserify" "npm install -g browserify"
    npm install -g browserify
    echo "OK"
fi

# bower
if which bower &> /dev/null; then
    msg_checking "bower"
else
    msg_install "bower" "npm install -g bower"
    npm install -g bower
    msg_ok "OK"
fi

# bower-installer
if which bower-installer &> /dev/null; then
    msg_checking "bower-installer"
else
    msg_install "bower-installer" "npm install -g bower-installer"
    npm install -g bower-installer
    msg_ok "OK"
fi
