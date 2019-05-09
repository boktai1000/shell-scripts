#!/usr/bin/env bash

# You can run this script directly with the following command
# Append your version number after 'sudo bash -s' ex: 'sudo bash -s 9.0.17'
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/tomcat/nix-choose-tomcat.sh | sudo bash -s 

# Set variables to pass parameter / argument to script to grab version number from website
tomcatlatest="$(curl -s https://api.github.com/repos/apache/tomcat/tags | grep '"name"' | head -1 | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")"
tomcatminorversion=${1:-$tomcatlatest}
tomcatmajorversion="$(echo "$tomcatminorversion" | cut -c1-1)"
yourip=$(hostname -I | awk '{print $1}')
jdkenv="$(cat /etc/profile.d/jdk*.sh | sed -nr '/JAVA_HOME=/ s/.*JAVA_HOME=([^"]+).*/\1/p' | head -1)"

groupadd tomcat
useradd -g tomcat -d /opt/tomcat -s /bin/nologin tomcat

(cd /tmp && curl -O https://archive.apache.org/dist/tomcat/tomcat-"$tomcatmajorversion"/v"$tomcatminorversion"/bin/apache-tomcat-"$tomcatminorversion".tar.gz)
tar -xzvf /tmp/apache-tomcat-"$tomcatminorversion".tar.gz -C /opt/tomcat --strip-components=1
(cd /opt/tomcat/webapps/ && sudo rm -rf docs examples manager host-manager)

chown -R tomcat:tomcat /opt/tomcat/

# Red Hat like specific commands and variables - only tested on CentOS
if [ -f /etc/redhat-release ]; then
    
    # Open Firewall ports for Tomcat
    echo 'Opening Firewall port 8080 TCP for Tomcat'
    firewall-cmd --zone=public --add-port=8080/tcp > /dev/null
    firewall-cmd --zone=public --permanent --add-port=8080/tcp > /dev/null
    
fi

# Debian like specific commands and variables - only tested on Ubuntu
if [ -f /etc/lsb-release ]; then
    
    # Open Firewall ports for Tomcat
    echo 'Opening Firewall port 8080 TCP for Tomcat'
    ufw allow 8080/tcp > /dev/null
    ufw reload
    
fi

echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=$jdkenv
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat.service

systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

# Echo a reminder to CLI on how to connect to Tomcat
echo Connect to Tomcat at http://"$yourip":8080
