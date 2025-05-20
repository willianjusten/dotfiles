##################
# Code # Color   #
##################
#  00  # Off     #
#  30  # Black   #
#  31  # Red     #
#  32  # Green   #
#  33  # Yellow  #
#  34  # Blue    #
#  35  # Magenta #
#  36  # Cyan    #
#  37  # White   #
##################

function msg_checking { echo -e "\033[1;32m[cheking] $1 ✔\033[0m"; }
function msg_update { echo -e "\033[1;33m[update] $1 \033[0m"; }
function msg_install { echo -e "\033[1;33m[installing] $1 \033[0m"; }
function msg_ok { echo -e "\033[1;32m[installed] $1 ✔\033[0m"; }
function msg_alert { echo -e "\033[1;31m[alert] ✖ $1 ✖\033[0m"; }
function msg { echo -e "\033[0;36m$1\033[0m"; }