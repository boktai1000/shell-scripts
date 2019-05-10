#!/bin/bash

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/tomcat/nix-choose-tomcat-port.sh | sudo bash -s 

# Set variables to pass parameter / argument to script to grab version number from website
# Append your version number, followed by http port, then shutdown port (and optionally third the ajp port)
# It is recommended to increment by one for each deployment, if you do not specify any ports the default port will be used.
tomcatlatest="$(curl -s https://archive.apache.org/dist/tomcat/tomcat-9/ | grep -Po '(?<=(<a href="v)).*(?=/">v)' | sort -rV | head -1)"
tomcatminorversion=${1:-$tomcatlatest}
tomcatmajorversion="$(echo "$tomcatminorversion" | cut -c1-1)"
yourip=$(hostname -I | awk '{print $1}')
tomcatport="${2-8080}"
tomcatshutdownport="${3:-8005}"
tomcatajpport="${4:-8009}"
jdkenv="$(cat /etc/profile.d/jdk*.sh | sed -nr '/JAVA_HOME=/ s/.*JAVA_HOME=([^"]+).*/\1/p' | head -1)"

groupadd tomcat
useradd -g tomcat -d /opt/tomcat -s /bin/nologin tomcat

(cd /tmp && curl -O https://archive.apache.org/dist/tomcat/tomcat-"$tomcatmajorversion"/v"$tomcatminorversion"/bin/apache-tomcat-"$tomcatminorversion".tar.gz)
mkdir -p /opt/tomcat && tar -xzvf /tmp/apache-tomcat-"$tomcatminorversion".tar.gz -C /opt/tomcat/tomcat"$tomcatmajorversion"-"$tomcatport" --strip-components=1
(cd /opt/tomcat/tomcat"$tomcatmajorversion"-"$tomcatport"/webapps/ && sudo rm -rf docs examples manager host-manager)

sed -i "s/8080/$tomcatport/g" /opt/tomcat/tomcat"$tomcatmajorversion"-"$tomcatport"/conf/server.xml
sed -i "s/8005/$tomcatshutdownport/g" /opt/tomcat/tomcat"$tomcatmajorversion"-"$tomcatport"/conf/server.xml
sed -i "s/8009/$tomcatajpport/g" /opt/tomcat/tomcat"$tomcatmajorversion"-"$tomcatport"/conf/server.xml

chown -R tomcat:tomcat /opt/tomcat/tomcat"$tomcatmajorversion"-"$tomcatport"/

# Red Hat like specific commands and variables - only tested on CentOS
if [ -f /etc/redhat-release ]; then
    
    # Open Firewall ports for Tomcat
    echo 'Opening Firewall port "$tomcatport" TCP for Tomcat'
    firewall-cmd --zone=public --add-port="$tomcatport"/tcp > /dev/null
    firewall-cmd --zone=public --permanent --add-port="$tomcatport"/tcp > /dev/null
    
fi

# Debian like specific commands and variables - only tested on Ubuntu
if [ -f /etc/lsb-release ]; then
    
    # Open Firewall ports for Tomcat
    echo 'Opening Firewall port "$tomcatport" TCP for Tomcat'
    ufw allow "$tomcatport"/tcp > /dev/null
    ufw reload
    
fi

echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=$jdkenv
Environment=CATALINA_PID=/opt/tomcat/tomcat$tomcatmajorversion-$tomcatport/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat/tomcat$tomcatmajorversion-$tomcatport
Environment=CATALINA_BASE=/opt/tomcat/tomcat$tomcatmajorversion-$tomcatport
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/tomcat$tomcatmajorversion-$tomcatport/bin/startup.sh
ExecStop=/opt/tomcat/tomcat$tomcatmajorversion-$tomcatport/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat"$tomcatmajorversion"-"$tomcatport".service

systemctl daemon-reload
systemctl enable tomcat"$tomcatmajorversion"-"$tomcatport"
systemctl start tomcat"$tomcatmajorversion"-"$tomcatport"

# Cleanup files
rm /tmp/apache-tomcat-"$tomcatminorversion".tar.gz

# Echo a reminder to CLI on how to connect to Tomcat
echo Connect to Tomcat at http://"$yourip":"$tomcatport"
