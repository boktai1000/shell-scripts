#!/bin/bash

# https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/
# https://www.ostechnix.com/setup-centralized-rsyslog-server-centos-7/

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/logging/rsyslog/nix-rsyslog-server-both.sh | sudo bash

# Backup /etc/rsyslog.conf
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak-"$(date --utc +%FT%T.%3NZ)"

# Configure Rsyslog to accept remote log messages using UDP port 514
sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf

# Configure Rsyslog to accept remote log messages using TCP port 514
sed -i 's/#$ModLoad imtcp/$ModLoad imtcp/g' /etc/rsyslog.conf
sed -i 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/g' /etc/rsyslog.conf

systemctl restart rsyslog

echo 'Opening Firewall port 514 TCP and UDP for Rsyslog'
firewall-cmd --add-port=514/udp > /dev/null
firewall-cmd --add-port=514/tcp > /dev/null
firewall-cmd --permanent --add-port=514/udp > /dev/null
firewall-cmd --permanent --add-port=514/tcp > /dev/null
