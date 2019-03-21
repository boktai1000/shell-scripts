# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/tomcat/linux-install-tomcat7.sh | sudo bash

# https://tecadmin.net/steps-to-install-tomcat-server-on-centos-rhel/
# https://www.howtoforge.com/tutorial/how-to-install-tomcat-on-centos-7.0/
# https://gist.github.com/drmalex07/e6e99dad070a78d5dab24ff3ae032ed1
# http://tomcat.apache.org/whichversion.html

# Set Variable to always download latest version of Tomcat 7 - Scrape Web Page for Version Number
tomcatversion="$(curl -i https://www-us.apache.org/dist/tomcat/tomcat-7/ | grep -Po '(?<=(<a href="v)).*(?=/">v)')"

cd /tmp
curl -O https://www-us.apache.org/dist/tomcat/tomcat-7/v$tomcatversion/bin/apache-tomcat-$tomcatversion.tar.gz
tar xzf apache-tomcat-$tomcatversion.tar.gz

mv apache-tomcat-$tomcatversion /usr/local/tomcat7

cd /usr/local/tomcat7/webapps/
sudo rm -rf docs examples manager host-manager

groupadd tomcat
useradd -g tomcat -d /opt/tomcat -s /bin/nologin tomcat

chown -R tomcat:tomcat /usr/local/tomcat7

firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/local/jdk-11.0.2
Environment=CATALINA_PID=/usr/local/tomcat7/temp/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat7
Environment=CATALINA_BASE=/usr/local/tomcat7
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/usr/local/tomcat7/bin/startup.sh
ExecStop=/usr/local/tomcat7/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat7.service

systemctl daemon-reload
systemctl enable tomcat7
systemctl start tomcat7
