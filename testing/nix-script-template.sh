#!/bin/bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/ | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/ | sudo bash

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')

if [ "$EUID" -ne "0" ]; then
    echo "This script must be run as root." >&2
    exit 1
fi
