#!/bin/bash

# Script to install Cockpit on CentOS 7. This script is not modular for RHEL 7 due to subscription-manager requirements
# Created by: Keegan Jacobson
# Based on: 
#   https://cockpit-project.org/running#centos
# Tested on CentOS 7
# You can run it directly with curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/centos7-install-cockpit.sh | sudo bash

# Install cockpit test
sudo yum -y install cockpit

# Enable cockpit
systemctl enable --now cockpit.socket

# Open firewall for cockpit
firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload
