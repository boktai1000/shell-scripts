#!/bin/bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/ | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/ | sudo bash

# ========================WIP========================
# https://www.jethrocarr.com/2007/04/26/vi-vs-vim-on-centosrhel/
# https://askubuntu.com/questions/438150/scripts-in-etc-profile-d-being-ignored
# https://askubuntu.com/questions/503216/how-can-i-set-a-single-bashrc-file-for-several-users/503222
# http://www.tldp.org/LDP/abs/html/sample-bashrc.html 
# Need to output file to /etc/skel/
# Need to source file
# Need to backup files
# Need to be able to regenerate files
# ========================WIP========================

if [ -f /usr/bin/vim ]; then
         alias vi='vim'
fi
