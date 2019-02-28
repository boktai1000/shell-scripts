#!/bin/bash

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/centos7-install-cockpit.sh | sudo bash

# Install cockpit
yum -y install cockpit sos

# Enable cockpit
systemctl enable --now cockpit.socket

# Configure firewall
firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload
