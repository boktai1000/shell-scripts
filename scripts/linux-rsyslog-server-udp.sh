# Backup /etc/rsyslog.conf
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak

# Configure the server to accept remote log messages using UDP
sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf

systemctl restart rsyslog

# Open Firewall for Rsyslog to receive
firewall-cmd --permanent --add-port=514/udp
firewall-cmd –reload
