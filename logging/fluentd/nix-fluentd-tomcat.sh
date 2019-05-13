#!/bin/bash

# Note - this currently has problems with the following
# * td-agent not being able to read or have permissions on Tomcat log directory
# https://github.com/fluent/fluentd-docker-image/issues/90
# https://github.com/fluent/fluentd/issues/1785
# https://github.com/fluent/fluentd-kubernetes-daemonset/issues/172
# https://github.com/openshift/origin/issues/8358
# https://groups.google.com/forum/#!topic/fluentd/R6LTWR8fG6o
# https://groups.google.com/forum/#!topic/fluentd/n0hXZUqM-KQ

# Changing location of Tomcat files
# https://stackoverflow.com/questions/36101935/tomcat-7-change-location-of-log-files

# Errors when installing Fluentd elasticsearch gem plugin
# https://github.com/treasure-data/omnibus-td-agent/issues/16
# https://www.digitalocean.com/community/tutorials/elasticsearch-fluentd-and-kibana-open-source-log-search-and-visualization

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/logging/fluentd/nix-fluentd-tomcat.sh | sudo bash -s

# Set Variable for syslogserver - otherwise append non-working default
syslogserver="${1:-x.x.x.x}"

# Install Elasticsearch plugin in td-agent
sudo /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch --no-document

# Check for errors
tail -n 20 /var/log/td-agent/td-agent.log

# Alternative error checking commands
# tail -f /var/log/td-agent/td-agent.log
# tail -n 20 /var/log/td-agent/td-agent.log
# less /var/log/td-agent/td-agent.log

# Fluentd configuration via http://www.tothenew.com/blog/collecting-tomcat-logs-using-fluentd-and-elasticsearch/

# Backup /etc/td-agent/td-agent.conf
sudo cp /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf.bak-"$(date --utc +%FT%T.%3NZ)"

# Create new td-agent.conf for Collecting Tomcat logs using Fluentd and Elasticsearch
sudo tee /etc/td-agent/td-agent.conf <<EOF
<source>
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
hostname \${hostname}
</record>
</filter>

<match tomcat.logs>
type elasticsearch
host $syslogserver
port 9200
logstash_format true
logstash_prefix tomcat.logs
flush_interval 1s
</match>
EOF

# Restart td-agent to apply changes
sudo systemctl restart td-agent.service
