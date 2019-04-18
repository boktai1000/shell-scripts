#!/bin/bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/cockpit/ubuntu-install-cockpit.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/cockpit/ubuntu-install-cockpit.sh | sudo bash

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')

# Install Cockpit
sudo apt-get install -y cockpit

# Echo a reminder to CLI on how to login to Cockpit
echo Login to Cockpit at https://"$yourip":9090
