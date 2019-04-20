#!/bin/bash

# Based on https://community.ubnt.com/t5/UniFi-Wireless/Installing-UniFi-on-CentOS7-as-a-service/m-p/1973439/highlight/true#M234790

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/unifi/el7-update-unifi.sh | sudo bash

#Set Version (LTS Stable)
unifiversion="$(curl -s https://help.ubnt.com/hc/en-us/articles/360008240754#1 | grep -a1 "LTS Stable</td>" | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")"

#Stop Service:
systemctl stop unifi

#Download latest software:
(cd /tmp && curl -O http://dl.ubnt.com/unifi/"$unifiversion"/UniFi.unix.zip)

#Extract UniFi Video software:
unzip /tmp/UniFi.unix.zip -d /opt/

#Set permissions:
chown -R unifi:unifi /opt/UniFi
chown -R unifi:unifi /var/opt/UniFi

#Start Service:
systemctl start unifi
