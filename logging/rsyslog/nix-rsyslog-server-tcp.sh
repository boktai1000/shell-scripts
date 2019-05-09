#!/bin/bash

# https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/
# https://www.ostechnix.com/setup-centralized-rsyslog-server-centos-7/

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/logging/rsyslog/nix-rsyslog-server-tcp.sh | sudo bash

# Backup /etc/rsyslog.conf
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak-"$(date --utc +%FT%T.%3NZ)"

# Red Hat like specific commands and variables - only tested on CentOS
if [ -f /etc/redhat-release ]; then
    
    # Configure Rsyslog to accept remote log messages using TCP port 514
    sed -i 's/#$ModLoad imtcp/$ModLoad imtcp/g' /etc/rsyslog.conf
    sed -i 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/g' /etc/rsyslog.conf
    
    systemctl restart rsyslog
    
    # Open Firewall for Rsyslog
    echo 'Opening Firewall port 514 TCP for Rsyslog'
    firewall-cmd --add-port=514/tcp > /dev/null
    firewall-cmd --permanent --add-port=514/tcp > /dev/null
    
fi

# Debian like specific commands and variables - only tested on Ubuntu
if [ -f /etc/lsb-release ]; then
    
    # Configure Rsyslog to accept remote log messages using TCP port 514
    sed -i 's/#module(load="imtcp")/module(load="imtcp")/g' /etc/rsyslog.conf
    sed -i 's/#input(type="imtcp" port="514")/input(type="imtcp" port="514")/g' /etc/rsyslog.conf
    
    systemctl restart rsyslog
    
    # Open Firewall for Rsyslog
    echo 'Opening Firewall port 514 TCP for Rsyslog'
    ufw allow 514/tcp > /dev/null
    ufw reload
    
fi
