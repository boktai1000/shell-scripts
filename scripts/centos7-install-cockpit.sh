#!/bin/bash

# Script to install Cockpit on CentOS 7. This script is not modular for RHEL 7 due to subscription-manager requirements
# Created by: Keegan Jacobson
# Based on: 
#   https://cockpit-project.org/running#centos
#   https://www.vultr.com/docs/how-to-install-cockpit-on-centos-7
# Tested on CentOS 7
# You can run it directly with curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/centos7-install-cockpit.sh | sudo bash

# Install cockpit
sudo yum -y install cockpit

# Enable cockpit
sudo systemctl enable --now cockpit.socket

# Configure firewall
sudo firewall-cmd --permanent --zone=public --add-service=cockpit
sudo firewall-cmd --reload
