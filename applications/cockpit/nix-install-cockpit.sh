#!/usr/bin/env bash

# https://gist.github.com/dirtmerchant/a32007dc2980bbccda3de0873e28340e

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/cockpit/nix-install-cockpit.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/cockpit/nix-install-cockpit.sh | sudo bash

if [ "$EUID" -ne "0" ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')

if [ -f /etc/redhat-release ]; then
    
    # Install cockpit
    yum -y install cockpit setroubleshoot-server sos

    # Enable cockpit

    systemctl enable --now cockpit.socket

    # Configure firewall
    firewall-cmd --permanent --zone=public --add-service=cockpit
    firewall-cmd --reload

    # Echo a reminder to CLI on how to login to Cockpit
    echo Login to Cockpit at https://"$yourip":9090
fi

if [ -f /etc/lsb-release ]; then
    
    # Install Cockpit
    sudo apt-get install -y cockpit
    
    # Echo a reminder to CLI on how to login to Cockpit
    echo Login to Cockpit at https://"$yourip":9090
fi
