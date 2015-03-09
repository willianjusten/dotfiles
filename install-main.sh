#!/bin/bash

source common/functions.sh

OSX=$(test "`uname`" == "Darwin" && echo "x")

sh brew/global.sh

sh node/global.sh

sh ruby/global.sh