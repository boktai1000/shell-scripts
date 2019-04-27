#!/bin/bash

# Source
# https://unix.stackexchange.com/a/425719 

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/screensaver/nix-disable-screensaver.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/customization/screensaver/nix-disable-screensaver.sh | sudo bash

# Disable Console screensaver
TERM=linux setterm -blank 0 -powerdown 0  -powersave off >/dev/tty0 </dev/tty0

# Validate settings - should return 0
echo Validate settings - should return 0 below
cat /sys/module/kernel/parameters/consoleblank
