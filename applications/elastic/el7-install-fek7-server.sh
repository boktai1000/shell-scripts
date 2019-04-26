#!/bin/bash

# Pre-reqs - Java 8 or OpenJDK 11
# Sources - Fluentd + Elasticsearch + Kibana
# https://docs.fluentd.org/v1.0/articles/free-alternative-to-splunk-by-fluentd
# https://docs.fluentd.org/v0.12/articles/free-alternative-to-splunk-by-fluentd

# Sources - Installing Elasticsearch + Kibana from rpm
# https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html
# https://www.elastic.co/guide/en/kibana/current/rpm.html
# https://www.tecmint.com/install-elasticsearch-logstash-and-kibana-elk-stack-on-centos-rhel-7/

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/elastic/el7-install-fek7-server.sh | sudo bash

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')

# Import the Elastic PGP key
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

# Create Elasticsearch 7 repo
echo "[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/elasticsearch.repo

# Install Elasticsearch 7
sudo yum install -y elasticsearch

# Backup elasticsearch.yml file and allow all hosts to communicate to it
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml-$(date --utc +%FT%T.%3NZ)
# This tweak needs to be validated further - use sed or echo, not both
# sed -i 's/#network.host: "localhost"/network.host: 0.0.0.0/g' /etc/elasticsearch/elasticsearch.yml
# echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

# Open Firewall 9200/tcp and Start Service
firewall-cmd --add-port=9200/tcp
firewall-cmd --add-port=9200/tcp --permanent

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

sudo systemctl start elasticsearch.service

# Create Kibana 7 repo
echo "[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/kibana.repo

# Install Kibana 7
sudo yum install -y kibana

# Backup kibana.yml file and allow all hosts to communicate to it
cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml.bak-$(date --utc +%FT%T.%3NZ)
# This tweak needs to be validated further - use sed or echo, not both
# sed -i 's/#server.host: "localhost"/server.host: 0.0.0.0/g' /etc/kibana/kibana.yml
# echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml
echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml

# Open Firewall 5601/tcp and Start Service
firewall-cmd --add-port=5601/tcp
firewall-cmd --add-port=5601/tcp --permanent

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service

sudo systemctl start kibana.service

# Test Elasticsearch
curl -X GET http://localhost:9200


# Pre-Fluentd Configuration
cp /etc/security/limits.conf /etc/security/limits.conf.bak-$(date --utc +%FT%T.%3NZ)
echo "root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536" >> /etc/security/limits.conf

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

sudo cp /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf.bak-$(date --utc +%FT%T.%3NZ)
echo "# get logs from syslog
<source>
  @type syslog
  port 42185
  tag syslog
</source>

# get logs from fluent-logger, fluent-cat or other fluentd instances
<source>
  @type forward
</source>

<match syslog.**>
  @type elasticsearch
  logstash_format true
  <buffer>
    flush_interval 10s # for testing
  </buffer>
</match>" > /etc/td-agent/td-agent.conf

# sudo systemctl restart td-agent.service
sudo systemctl start td-agent.service

echo "*.* @127.0.0.1:42185" >> /etc/rsyslog.conf
sudo systemctl restart rsyslog

# To manually send logs to Elasticsearch, please use the logger command.
logger -t test foobar

# Check for errors
# tail -f /var/log/td-agent/td-agent.log
# tail -n 20 /var/log/td-agent/td-agent.log
# less /var/log/td-agent/td-agent.log
tail -n 20 /var/log/td-agent/td-agent.log

# Echo a reminder to CLI on how to connect to Kibana
echo Connect to Kibana at http://"$yourip":5601
