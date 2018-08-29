#!/bin/bash

# Script to install Cockpit on CentOS 7. This script is not modular for RHEL 7 due to subscription-manager requirements
# Created by: Keegan Jacobson
# Based on: 
#   https://cockpit-project.org/running#centos
#   https://www.vultr.com/docs/how-to-install-cockpit-on-centos-7
# Tested on CentOS 7
# You can run it directly with curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/centos7-install-cockpit.sh | sudo bash

# Install cockpit
yum -y install cockpit

# Enable cockpit
systemctl enable --now cockpit.socket

# Configure firewall
firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload

# Fix https://github.com/cockpit-project/cockpit/issues/9193
# Remove subscription-manager as it is not desirable, this should be able to be removed when CentOS 7.6 is released
sudo sed -i 's/enabled=0/enabled=1/' /etc/yum/pluginconf.d/subscription-manager.conf /etc/yum/pluginconf.d/search-disabled-repos.conf /etc/yum/pluginconf.d/product-id.conf
mv /etc/dbus-1/system.d/com.redhat.SubscriptionManager.conf{,.back}
