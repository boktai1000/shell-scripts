#!/bin/bash

# Source
# https://unix.stackexchange.com/a/425719 

# Disable Console screensaver
TERM=linux setterm -blank 0 -powerdown 0  -powersave off >/dev/tty0 </dev/tty0

# Validate settings - should return 0
cat /sys/module/kernel/parameters/consoleblank
