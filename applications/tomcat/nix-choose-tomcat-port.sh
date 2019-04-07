# You can run this script directly with the following command
# Append your version number followed by desired port number after 'sudo bash -s' ex: 'sudo bash -s 9.0.17 9090'
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/tomcat/nix-choose-tomcat-port.sh | sudo bash -s 

# Set variables to pass parameter / argument to script to grab version number from website
tomcatmajorversion="`echo $1 | cut -c1-1`"
tomcatminorversion="$1"
yourip=$(hostname -I | awk '{print $1}')
tomcatport="${2-8080}"

cd /tmp
curl -O https://archive.apache.org/dist/tomcat/tomcat-$tomcatmajorversion/v$tomcatminorversion/bin/apache-tomcat-$tomcatminorversion.tar.gz
tar -xzvf apache-tomcat-$tomcatminorversion.tar.gz -C /opt

cd /opt
mv apache-tomcat-$tomcatminorversion tomcat$tomcatmajorversion-$tomcatport

cd /opt/tomcat$tomcatmajorversion-$tomcatport/webapps/
sudo rm -rf docs examples manager host-manager

groupadd tomcat
useradd -g tomcat -d /opt/tomcat -s /bin/nologin tomcat

chown -R tomcat:tomcat /opt/tomcat$tomcatmajorversion-$tomcatport/

firewall-cmd --zone=public --permanent --add-port=$tomcatport/tcp
firewall-cmd --reload

sed -i "s/8080/$tomcatport/g" /opt/tomcat$tomcatmajorversion-$tomcatport/conf/server.xml

echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/local/jdk-11.0.2
Environment=CATALINA_PID=/opt/tomcat$tomcatmajorversion-$tomcatport/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat$tomcatmajorversion-$tomcatport
Environment=CATALINA_BASE=/opt/tomcat$tomcatmajorversion-$tomcatport
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat$tomcatmajorversion-$tomcatport/bin/startup.sh
ExecStop=/opt/tomcat$tomcatmajorversion-$tomcatport/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat$tomcatmajorversion-$tomcatport.service

systemctl daemon-reload
systemctl enable tomcat$tomcatmajorversion-$tomcatport
systemctl start tomcat$tomcatmajorversion-$tomcatport

# Echo a reminder to CLI on how to connect to Tomcat
echo Connect to Tomcat at https://$yourip:$tomcatport
