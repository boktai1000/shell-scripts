#!/bin/bash

# https://linuxconfig.org/disable-automatic-updates-on-ubuntu-18-04-bionic-beaver-linux

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/updates/deb-disable-autoupdate.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/security/updates/deb-disable-autoupdate.sh | sudo bash

sudo cp /etc/apt/apt.conf.d/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades-"$(date --utc +%FT%T.%3NZ)"
sudo sed -i 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/g' /etc/apt/apt.conf.d/20auto-upgrades
