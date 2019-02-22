# You can run it directly with curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/install-tomcat9.sh | sudo bash

curl -O https://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.16/bin/apache-tomcat-9.0.16.tar.gz
tar -xzvf apache-tomcat-9.0.16.tar.gz -C /opt

cd /opt
mv apache-tomcat-9.0.16 tomcat

cd /opt/tomcat/webapps/
sudo rm -rf docs examples manager host-manager

groupadd tomcat
useradd -g tomcat -d /opt/tomcat -s /bin/nologin tomcat

chown -R tomcat:tomcat /opt/tomcat/

firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

echo "[Unit]" > /etc/systemd/system/tomcat.service
echo "Description=Apache Tomcat Web Application Container" >> /etc/systemd/system/tomcat.service
echo "After=network.target" >> /etc/systemd/system/tomcat.service
echo >> /etc/systemd/system/tomcat.service
echo "[Service]" >> /etc/systemd/system/tomcat.service
echo "Type=forking" >> /etc/systemd/system/tomcat.service
echo >> /etc/systemd/system/tomcat.service
echo "Environment=JAVA_HOME=/usr/local/jdk-11.0.2" >> /etc/systemd/system/tomcat.service
echo "Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid" >> /etc/systemd/system/tomcat.service
echo "Environment=CATALINA_HOME=/opt/tomcat" >> /etc/systemd/system/tomcat.service
echo "Environment=CATALINA_BASE=/opt/tomcat" >> /etc/systemd/system/tomcat.service
echo "Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'" >> /etc/systemd/system/tomcat.service
echo "Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'" >> /etc/systemd/system/tomcat.service
echo >> /etc/systemd/system/tomcat.service
echo "ExecStart=/opt/tomcat/bin/startup.sh" >> /etc/systemd/system/tomcat.service
echo "ExecStop=/opt/tomcat/bin/shutdown.sh" >> /etc/systemd/system/tomcat.service
echo >> /etc/systemd/system/tomcat.service
echo "User=tomcat" >> /etc/systemd/system/tomcat.service
echo "Group=tomcat" >> /etc/systemd/system/tomcat.service
echo "UMask=0007" >> /etc/systemd/system/tomcat.service
echo "RestartSec=10" >> /etc/systemd/system/tomcat.service
echo "Restart=always" >> /etc/systemd/system/tomcat.service
echo >> /etc/systemd/system/tomcat.service
echo "[Install]" >> /etc/systemd/system/tomcat.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/tomcat.service

systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat
