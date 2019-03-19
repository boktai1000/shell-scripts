#Based on https://community.ubnt.com/t5/UniFi-Wireless/Installing-UniFi-on-CentOS7-as-a-service/m-p/1973439/highlight/true#M234790

#You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/unifi/el7-install-unifi.sh | sudo bash

#Set Versions (LTS Stable + MongoDB Version 3.4 Recommended)
unifiversion="$(curl -L --silent https://help.ubnt.com/hc/en-us/articles/360008240754#1 | grep -a1 "LTS Stable</td>" | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")"
mongodbversion="3.4"

#Create mongodb Repo file
rpm --import https://www.mongodb.org/static/pgp/server-$mongodbversion.asc

touch /etc/yum.repos.d/mongodb-org-$mongodbversion.repo
echo "[mongodb-org-$mongodbversion]" > /etc/yum.repos.d/mongodb-org-$mongodbversion.repo
echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb-org-$mongodbversion.repo
echo "baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/$mongodbversion/x86_64/" >> /etc/yum.repos.d/mongodb-org-$mongodbversion.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-org-$mongodbversion.repo
echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-$mongodbversion.repo

#Install pre-requisites and update OS:
yum install -y lsb wget unzip nano java mongodb-org
yum update -y

#Create UniFi directories:
mkdir -p /opt/UniFi/
mkdir -p /var/opt/UniFi/data
ln -s /var/opt/UniFi/data /opt/UniFi/5

#Download UniFi software:
cd /usr/src
wget "http://dl.ubnt.com/unifi/$unifiversion/UniFi.unix.zip" -O /usr/src/UniFi.unix.zip

#Extract UniFi software:
unzip UniFi.unix.zip -d /opt/

#Create unifi service:
touch /etc/systemd/system/unifi.service
echo "[Unit]" > /etc/systemd/system/unifi.service
echo "Description=UniFi" >> /etc/systemd/system/unifi.service
echo "After=syslog.target" >> /etc/systemd/system/unifi.service
echo "After=network.target" >> /etc/systemd/system/unifi.service
echo -e "\n" >> /etc/systemd/system/unifi.service
echo "[Service]" >> /etc/systemd/system/unifi.service
echo "Type=simple" >> /etc/systemd/system/unifi.service
echo "User=unifi" >> /etc/systemd/system/unifi.service
echo "Group=unifi" >> /etc/systemd/system/unifi.service
echo -e "\n" >> /etc/systemd/system/unifi.service
echo "ExecStart=/usr/bin/java -jar /opt/UniFi/lib/ace.jar start" >> /etc/systemd/system/unifi.service
echo "ExecStop=/usr/bin/java -jar /opt/UniFi/lib/ace.jar stop" >> /etc/systemd/system/unifi.service
echo "# Give a reasonable amount of time for the server to start up/shut down" >> /etc/systemd/system/unifi.service
echo "TimeoutSec=300" >> /etc/systemd/system/unifi.service
echo -e "\n" >> /etc/systemd/system/unifi.service
echo "[Install]" >> /etc/systemd/system/unifi.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/unifi.service

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
