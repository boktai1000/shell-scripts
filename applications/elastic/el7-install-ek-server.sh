#!/bin/bash

# https://gist.github.com/hideojoho/89e24e932f2b69d43ef31d707a57ed24
# https://gist.githubusercontent.com/hideojoho/89e24e932f2b69d43ef31d707a57ed24/raw/dcf95670c3082a29065165195eae9ec695de5fa6/Vagrant_provision.sh

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
sudo yum install -y elasticsearch

# Backup elasticsearch.yml file and allow all hosts to communicate to it
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml-"$(date --utc +%FT%T.%3NZ)"

sudo echo "network.host: $yourip" | sudo tee --append /etc/elasticsearch/elasticsearch.yml
sudo echo "discovery.seed_hosts: [\"$yourip\"]" | sudo tee --append /etc/elasticsearch/elasticsearch.yml
sudo echo "cluster.initial_master_nodes: [\"$yourip\"]" | sudo tee --append /etc/elasticsearch/elasticsearch.yml

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
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
cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml.bak-"$(date --utc +%FT%T.%3NZ)"

sudo echo "server.host: $yourip" | sudo tee --append /etc/kibana/kibana.yml
sudo echo "elasticsearch.hosts: [\"http://$yourip:9200\"]" | sudo tee --append /etc/kibana/kibana.yml

sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service

# Echo a reminder to CLI on how to connect to Kibana
echo Connect to Kibana at http://"$yourip":5601
