source common/functions.sh

# nodejs
if which node &> /dev/null; then
    msg_checking "node"
else
    msg_install "node" "git clone git://github.com/ry/node.git"
    brew install node
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

# jade
if which jade &> /dev/null; then
    msg_checking "jade"
else
    msg_install "jade" "npm install -g jade"
    npm install -g jade
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

# vtop
if which vtop &> /dev/null; then
    msg_checking "vtop"
else
    msg_install "vtop" "npm install vtop -g"
    npm install vtop -g
    echo "OK"
fi

# jshint
if which jshint &> /dev/null; then
    msg_checking "jshint"
else
    msg_install "jshint" "npm install jshint -g"
    npm install jshint -g
    echo "OK"
fi

# csslint
if which csslint &> /dev/null; then
    msg_checking "csslint"
else
    msg_install "csslint" "npm install -g csslint"
    npm install -g csslint
    msg_ok "OK"
fi

# TMI (Too Many Images) - discover your image weight on the web [alpha]
if which tmi &> /dev/null; then
    msg_checking "tmi"
else
    msg_install "tmi" "npm install -g tmi"
    npm install -g tmi
    msg_ok "OK"
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
