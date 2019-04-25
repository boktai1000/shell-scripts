# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/tomcat/nix-install-tomcat9.sh | sudo bash

# Set Variable to always download latest version of Tomcat 9 - Scrape Web Page for Version Number
tomcatversion="$(curl -s https://www-us.apache.org/dist/tomcat/tomcat-9/ | grep -Po '(?<=(<a href="v)).*(?=/">v)' | head -1)"
yourip=$(hostname -I | awk '{print $1}')

if [ -z "$JAVA_HOME" ]; then
    echo "Need to install JDK"
    exit 1
fi  

groupadd tomcat
useradd -g tomcat -d /opt/tomcat -s /bin/nologin tomcat

cd /tmp
curl -O https://www-us.apache.org/dist/tomcat/tomcat-9/v$tomcatversion/bin/apache-tomcat-$tomcatversion.tar.gz
tar -xzvf apache-tomcat-$tomcatversion.tar.gz -C /opt

cd /opt
mv apache-tomcat-$tomcatversion tomcat

cd /opt/tomcat/webapps/
sudo rm -rf docs examples manager host-manager

chown -R tomcat:tomcat /opt/tomcat/

firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=$JAVA_HOME
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
echo Connect to Tomcat at http://$yourip:8080
