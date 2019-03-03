# Pre-reqs - Java 8 or OpenJDK 11
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/install-openjdk11-alt.sh | sudo bash

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/el7-install-efk.sh | sudo bash

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

sudo yum install elasticsearch -y

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

sudo systemctl start elasticsearch.service

# Test Elasticsearch
curl -X GET http://localhost:9200

# Install Kibana
echo "[kibana-6.x]
name=Kibana repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/kibana.repo

sudo yum install kibana -y

# This tweak needs to be validated further - use sed or echo, not both
# sed -i 's/#server.host: "localhost"/server.host: 0.0.0.0/g' /etc/kibana/kibana.yml
# echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml
echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml

firewall-cmd --add-port=5601/tcp
firewall-cmd --add-port=5601/tcp --permanent

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service

sudo systemctl start kibana.service
