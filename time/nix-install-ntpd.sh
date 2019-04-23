#!/bin/bash

# https://linuxadmin.io/install-ntpd-centos-7/
# https://www.tecmint.com/install-ntp-server-in-centos/

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/time/nix-install-ntpd.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/time/nix-install-ntpd.sh | sudo bash

# Set Variables
NTP_SERVER1=$1
NTP_SERVER2=$2
NTP_SERVER3=$3
NTP_SERVER4=$4

# Stop built-in chronyd
systemctl stop chronyd.service
systemctl disable chronyd.service

# Red Hat like specific commands and variables - only tested on CentOS
if [ -f /etc/redhat-release ]; then
    
    # Install NTP
    yum install -y ntp
    
    # Open Firewall
    firewall-cmd --add-service=ntp --permanent
    firewall-cmd --reload
fi

# Backup default configuration
cp -a /etc/ntp.conf "/etc/ntp.conf-$(date --utc +%FT%T.%3NZ)"

# add first ntp server to configuration file
echo "server $NTP_SERVER1 iburst" > /etc/ntp.conf

# add second ntp server to configuration file
if [ -z "$2" ]
then
    echo "Second NTP Server not given"
else
    echo "server $NTP_SERVER2 iburst" >> /etc/ntp.conf
fi

# add third ntp server to configuration file
if [ -z "$3" ]
then
    echo "Third NTP Server not given"
else
    echo "server $NTP_SERVER3 iburst" >> /etc/ntp.conf
fi

# add fourth ntp server to configuration file
if [ -z "$4" ]
then
    echo "Fourth NTP Server not given"
else
    echo "server $NTP_SERVER4 iburst" >> /etc/ntp.conf
fi

# Show ntpd configuration file
echo "==Displaying NTP configuration file=="
cat /etc/ntp.conf
