# Pre-reqs - Java 8 or OpenJDK 11
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/install-openjdk11-alt.sh | sudo bash

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/el7-install-efk-server.sh | sudo bash

# Install Elasticsearch
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

echo "[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/elasticsearch.repo

sudo yum install -y elasticsearch

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

sudo systemctl start elasticsearch.service

# Install Kibana
echo "[kibana-6.x]
name=Kibana repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/kibana.repo

sudo yum install -y kibana

# This tweak needs to be validated further - use sed or echo, not both
# sed -i 's/#server.host: "localhost"/server.host: 0.0.0.0/g' /etc/kibana/kibana.yml
# echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml
echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml

firewall-cmd --add-port=5601/tcp
firewall-cmd --add-port=5601/tcp --permanent

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service

sudo systemctl start kibana.service

# Test Elasticsearch
curl -X GET http://localhost:9200


# Pre-Fluentd Configuration
cp /etc/security/limits.conf /etc/security/limits.conf.bak
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

sudo cp /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf.bak
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
