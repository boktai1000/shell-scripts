#!/bin/bash

# WIP - Needs validation, further testing, firewall evaluation, and Fluentd setup

# Sources - Fluentd + Elasticsearch + Kibana
# https://docs.fluentd.org/v1.0/articles/free-alternative-to-splunk-by-fluentd
# https://docs.fluentd.org/v0.12/articles/free-alternative-to-splunk-by-fluentd

# Sources - Installing Elasticsearch + Kibana from deb
# https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html
# https://www.elastic.co/guide/en/kibana/current/deb.html 

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/elastic/deb-install-fek7-server.sh | sudo bash

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')

# Import the Elastic PGP key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Add Elastic APT repo
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

# Install Elasticsearch
sudo apt-get update && sudo apt-get install elasticsearch

# Backup elasticsearch.yml file and allow all hosts to communicate to it
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.bak-"$(date --utc +%FT%T.%3NZ)"

echo "network.host: 0.0.0.0" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo "discovery.seed_hosts: [\"$yourip\"]" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo "cluster.initial_master_nodes: [\"$yourip\"]" | sudo tee -a /etc/elasticsearch/elasticsearch.yml

# Run Elasticsearch via systemd
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

# Test Elasticsearch
curl -X GET http://localhost:9200

# Install Kibana
sudo apt-get update && sudo apt-get install kibana

# Backup kibana.yml file and allow all hosts to communicate to it
cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml.bak-"$(date --utc +%FT%T.%3NZ)"

echo "server.host: $yourip" | sudo tee -a /etc/kibana/kibana.yml
echo "elasticsearch.hosts: [\"http://$yourip:9200\"]" | sudo tee -a /etc/kibana/kibana.yml

# Run Kibana via systemd
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service

# Echo a reminder to CLI on how to connect to Kibana
echo Connect to Kibana at http://"$yourip":5601
