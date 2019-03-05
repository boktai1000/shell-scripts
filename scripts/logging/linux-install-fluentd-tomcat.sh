# SCRIPT WIP - DOES NOT COMPLETELY WORK - PLEASE EDIT `host` line to your IP Address

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/logging/linux-install-fluentd-tomcat.sh | sudo bash

# Pre-Fluentd Configuration
cp /etc/security/limits.conf /etc/security/limits.conf.bak
echo "root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536" >> /etc/security/limits.conf

# Please reboot to have changes take effect
# ulimit -n
# 1024 = insufficient;65536 = safe

cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo "net.core.somaxconn = 1024
net.core.netdev_max_backlog = 5000
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_wmem = 4096 12582912 16777216
net.ipv4.tcp_rmem = 4096 12582912 16777216
net.ipv4.tcp_max_syn_backlog = 8096
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10240 65535" >> /etc/sysctl.conf

sysctl -p

# Install Fluentd (td-agent v3)
curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
sudo /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch --no-document

sudo systemctl start td-agent.service

# Check for errors
# tail -f /var/log/td-agent/td-agent.log
# tail -n 20 /var/log/td-agent/td-agent.log
# less /var/log/td-agent/td-agent.log
tail -n 20 /var/log/td-agent/td-agent.log

# Fluentd configuration via http://www.tothenew.com/blog/collecting-tomcat-logs-using-fluentd-and-elasticsearch/
sudo cp /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf.bak
echo "<source>
type tail
format multiline
format_firstline /[0-9]{2}-[A-Za-z]{3}-[0-9]{4}/
format1 /^(?<datetime>[0-9]{2}-[A-Za-z]{3}-[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}) (?<Log-Level>[A-Z]*) (?<message>.*)$/
path /opt/tomcat/logs/catalina.out
tag tomcat.logs
</source>

<filter tomcat.logs>
type record_transformer
<record>
hostname ${hostname}
</record>
</filter>

<match tomcat.logs>
type elasticsearch
host 0.0.0.0
port 9200
logstash_format true
logstash_prefix tomcat.logs
flush_interval 1s
</match>" > /etc/td-agent/td-agent.conf

sudo systemctl restart td-agent.service
