#!/bin/bash

# Script to install Cockpit on CentOS 7. This script is not modular for RHEL 7 due to subscription-manager requirements
# Created by: Keegan Jacobson
# Based on: 
#   https://cockpit-project.org/running#centos
#   https://www.vultr.com/docs/how-to-install-cockpit-on-centos-7
# Tested on CentOS 7
# You can run it directly with the follow command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/centos7-install-cockpit.sh | sudo bash

# Install cockpit
yum -y install cockpit sos

# Enable cockpit
systemctl enable --now cockpit.socket

# Configure firewall
firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload
