# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/linux-install-tomcat7.sh | sudo bash

# https://tecadmin.net/steps-to-install-tomcat-server-on-centos-rhel/
# https://www.howtoforge.com/tutorial/how-to-install-tomcat-on-centos-7.0/
# https://gist.github.com/drmalex07/e6e99dad070a78d5dab24ff3ae032ed1
# http://tomcat.apache.org/whichversion.html

cd /tmp
curl -O https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.93/bin/apache-tomcat-7.0.93.tar.gz
tar xzf apache-tomcat-7.0.93.tar.gz

mv apache-tomcat-7.0.93 /usr/local/tomcat7

cd /usr/local/tomcat7/webapps/
sudo rm -rf docs examples manager host-manager

groupadd tomcat
useradd -g tomcat -d /opt/tomcat -s /bin/nologin tomcat

chown -R tomcat:tomcat /usr/local/tomcat7

firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

echo "[Unit]
Description=Tomcat - instance %i
After=syslog.target network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

WorkingDirectory=/usr/local/tomcat7/%i

Environment="JAVA_HOME=/usr/local/jdk-11.0.2"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_PID=/usr/local/tomcat7/%i/run/tomcat.pid"
Environment="CATALINA_BASE=/usr/local/tomcat7/%i/"
Environment="CATALINA_HOME=/usr/local/tomcat7"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/usr/local/tomcat7/bin/startup.sh
ExecStop=/usr/local/tomcat7/bin/shutdown.sh

#RestartSec=10
#Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat7.service

systemctl daemon-reload
systemctl enable tomcat7
systemctl start tomcat7
