#!/bin/bash

# https://gist.github.com/hideojoho/89e24e932f2b69d43ef31d707a57ed24
# https://gist.githubusercontent.com/hideojoho/89e24e932f2b69d43ef31d707a57ed24/raw/dcf95670c3082a29065165195eae9ec695de5fa6/Vagrant_provision.sh

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/elastic/el7-install-ek7-server.sh | sudo bash

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')

# Open Firewall for Elasticsearch and Kibana
firewall-cmd --add-port=5601/tcp
firewall-cmd --add-port=5601/tcp --permanent
firewall-cmd --add-port=9200/tcp
firewall-cmd --add-port=9200/tcp --permanent
firewall-cmd --reload

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
yum install -y elasticsearch

# Backup elasticsearch.yml file and allow all hosts to communicate to it
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.bak-"$(date --utc +%FT%T.%3NZ)"

echo "network.host: 0.0.0.0 | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo "discovery.seed_hosts: [\"$yourip\"]" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo "cluster.initial_master_nodes: [\"$yourip\"]" | sudo tee -a /etc/elasticsearch/elasticsearch.yml

systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

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
yum install -y kibana

# Backup kibana.yml file and allow all hosts to communicate to it
cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml.bak-"$(date --utc +%FT%T.%3NZ)"

echo "server.host: $yourip" | sudo tee -a /etc/kibana/kibana.yml
echo "elasticsearch.hosts: [\"http://$yourip:9200\"]" | sudo tee -a /etc/kibana/kibana.yml

systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service

# Test Elasticsearch
curl -X GET http://"$yourip":9200

# Echo a reminder to CLI on how to connect to Kibana
echo Connect to Kibana at http://"$yourip":5601
