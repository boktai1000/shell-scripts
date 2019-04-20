#!/bin/bash

# https://community.ubnt.com/t5/UniFi-Wireless/Installing-UniFi-on-CentOS7-as-a-service/m-p/1973439/highlight/true#M234790

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/unifi/el7-install-unifi.sh | sudo bash

#Set Versions (LTS Stable + MongoDB Version 3.4 Recommended)
unifiversion="$(curl -s https://help.ubnt.com/hc/en-us/articles/360008240754#1 | grep -a1 "LTS Stable</td>" | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")"
mongodbversion="3.4"

#Create mongodb Repo file
rpm --import https://www.mongodb.org/static/pgp/server-$mongodbversion.asc

echo "[mongodb-org-$mongodbversion]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/$mongodbversion/x86_64/
gpgcheck=1
enabled=1" > /etc/yum.repos.d/mongodb-org-$mongodbversion.repo

#Install pre-requisites and update OS:
yum install -y lsb unzip nano java mongodb-org
yum update -y

#Create UniFi directories:
mkdir -p /opt/UniFi/
mkdir -p /var/opt/UniFi/data
ln -s /var/opt/UniFi/data /opt/UniFi/5

#Download UniFi software:
(cd /tmp && curl -O http://dl.ubnt.com/unifi/"$unifiversion"/UniFi.unix.zip)

#Extract UniFi software:
unzip /tmp/UniFi.unix.zip -d /opt/

#Create unifi service:
echo "[Unit]
Description=UniFi
After=syslog.target
After=network.target
[Service]
Type=simple
User=unifi
Group=unifi
ExecStart=/usr/bin/java -jar /opt/UniFi/lib/ace.jar start
ExecStop=/usr/bin/java -jar /opt/UniFi/lib/ace.jar stop
# Give a reasonable amount of time for the server to start up/shut down
TimeoutSec=300
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/unifi.service

ln -s /etc/systemd/system/unifi.service /var/opt/UniFi/unifi.service
ln -s /etc/systemd/system/unifi.service /usr/lib/systemd/system/unifi.service

#Create User and set permissions:
useradd -M unifi
usermod -L unifi
usermod -s /bin/false unifi
chown -R unifi:unifi /opt/UniFi
chown -R unifi:unifi /var/opt/UniFi

#Configure firewall rules:
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=8443/tcp --permanent
firewall-cmd --zone=public --add-port=8880/tcp --permanent
firewall-cmd --zone=public --add-port=8843/tcp --permanent
firewall-cmd --zone=public --add-port=3478/udp --permanent
firewall-cmd --zone=public --add-port=3478/tcp --permanent
firewall-cmd --zone=public --add-port=10001/udp --permanent

systemctl restart firewalld

#Enable and start service:
systemctl enable unifi
systemctl start unifi
systemctl status unifi
