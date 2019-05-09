#!/bin/bash

# http://idmoim.blogspot.com/2016/09/sending-tomcat-logs-to-syslog-servers.html

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/logging/tomcat/nix-tomcat-rsyslog-udp.sh | sudo bash -s

# Set Variable for Syslog server to send to, if no Syslog specified then fallback to x.x.x.x to replace later.
syslogserver=${1:-x.x.x.x}
yourip=$(hostname -I | awk '{print $1}')

# Configuring the tomcat.conf file
sudo tee /etc/rsyslog.d/tomcat.conf <<EOF
# File 1
input(type="imfile"
      File="/opt/tomcat*/logs/*"
      Tag="catalina"
      Severity="info"
      Facility="local1")
local1.* @$syslogserver:514"
EOF

# Backup /etc/rsyslog.conf
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak-"$(date --utc +%FT%T.%3NZ)"

# Configuring the rsyslog.conf - load the imfile module
sed -i '22a\module(load="imfile" PollingInterval="10")' /etc/rsyslog.conf

# Configuring the rsyslog.conf - Configure the messages
sed -i 's/cron.none/cron.none;local1.none/g' /etc/rsyslog.conf

# Configure rsyslog to send rsyslog events to another server using TCP
sed -i "s/# ### end of the forwarding rule ###/*.* @$syslogserver:514/g" /etc/rsyslog.conf
echo "# ### end of the forwarding rule ###" >> /etc/rsyslog.conf

# Configuring the rsyslog.conf - Restart the rsyslog daemon
systemctl restart rsyslog

# Test the configuration
logger Test from $yourip
tail /var/log/messages

# Replace y.y.y.y with your server IP and run these commands against your system otherwise it will not work
# sed -i 's/x.x.x.x/y.y.y.y/g' /etc/rsyslog.d/tomcat.conf
# sed -i 's/x.x.x.x/y.y.y.y/g' /etc/rsyslog.conf
# systemctl restart rsyslog
