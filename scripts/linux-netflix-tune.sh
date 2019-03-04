# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/linux-netflix-tune.sh | sudo bash

# Sources
# https://www.slideshare.net/brendangregg/how-netflix-tunes-ec2-instances-for-performance
# https://docs.fluentd.org/v1.0/articles/before-install
# https://docs.fluentd.org/v0.12/articles/before-install

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
