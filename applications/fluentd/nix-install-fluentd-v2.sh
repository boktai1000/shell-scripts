#!/bin/bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/fluentd/nix-install-fluentd-v2.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/fluentd/nix-install-fluentd-v2.sh | sudo bash

# Set Variable for your IP Address
# yourip=$(hostname -I | awk '{print $1}')

if [ "$EUID" -ne "0" ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# ==============Before Installing Fluentd==============
# https://docs.fluentd.org/v0.12/articles/before-install
# https://www.slideshare.net/brendangregg/how-netflix-tunes-ec2-instances-for-performance

# Backup /etc/security/limits.conf before modifying
cp /etc/security/limits.conf /etc/security/limits.conf.bak-"$(date --utc +%FT%T.%3NZ)"

# Increase Max # of File Descriptors
sudo tee -a /etc/security/limits.conf <<EOF
root soft nofile 65536
root hard nofile 65536
* soft nofile 65536
* hard nofile 65536
EOF

# Backup /etc/sysctl.conf before modifying
cp /etc/sysctl.conf /etc/sysctl.conf.bak-"$(date --utc +%FT%T.%3NZ)"

# Optimize Network Kernel Parameters
sudo tee -a /etc/sysctl.conf <<EOF
net.core.somaxconn = 1024
net.core.netdev_max_backlog = 5000
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_wmem = 4096 12582912 16777216
net.ipv4.tcp_rmem = 4096 12582912 16777216
net.ipv4.tcp_max_syn_backlog = 8096
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10240 65535
EOF

# Apply Network Kernel Parameters without reboot
sysctl -p

# ==================Installing Fluentd==================
# https://docs.fluentd.org/v0.12/articles/install-by-rpm
# https://docs.fluentd.org/v0.12/articles/install-by-deb
# https://gist.github.com/christronyxyocum/f10bf4f942e99ae00e18a497aad595a8
# https://stackoverflow.com/questions/12545066/shell-script-to-check-ubuntu-version-and-then-copy-files

# Installing Fluentd Using rpm Package
if [ -f /etc/redhat-release ]; then
    
    # CentOS and RHEL 5, 6, 7
    echo 'Installing Fluentd td-agent from https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh'
    curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
    
fi

# Installing Fluentd Using deb Package
if [ -f /etc/debian_version ]; then
    DIST="$(lsb_release -cs)"
    
    # Ubuntu Xenial - 16.04
    if [ "${DIST}" = "xenial" ]; then
        echo 'Installing Fluentd td-agent from https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.sh'
        curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.sh | sh
    fi
    
    # Ubuntu Trusty - 14.04
    if [ "${DIST}" = "trusty" ]; then
        echo 'Installing Fluentd td-agent from https://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh'
        curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh
    fi
    
    # Ubuntu Precise - 12.04
    if [ "${DIST}" = "precise" ]; then
        echo 'Installing Fluentd td-agent from https://toolbelt.treasuredata.com/sh/install-ubuntu-precise-td-agent2.sh'
        curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-precise-td-agent2.sh | sh
    fi
    
    # Ubuntu Lucid - 10.04
    if [ "${DIST}" = "lucid" ]; then
        echo 'Installing Fluentd td-agent from https://toolbelt.treasuredata.com/sh/install-ubuntu-lucid-td-agent2.sh'
        curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-lucid-td-agent2.sh | sh
    fi
    
    # Debian 9 (Stretch)
    if [ "${DIST}" = "stretch" ]; then
        echo 'Installing Fluentd td-agent from https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent2.sh'
        curl -L https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent2.sh | sh
    fi
    
    # Debian 8 (Jessie)
    if [ "${DIST}" = "jessie" ]; then
        echo 'Installing Fluentd td-agent from https://toolbelt.treasuredata.com/sh/install-debian-jessie-td-agent2.sh'
        curl -L https://toolbelt.treasuredata.com/sh/install-debian-jessie-td-agent2.sh | sh
    fi
    
    # Debian 7 (Wheezy)
    if [ "${DIST}" = "wheezy" ]; then
        echo 'Installing Fluentd td-agent from https://toolbelt.treasuredata.com/sh/install-debian-wheezy-td-agent2.sh'
        curl -L https://toolbelt.treasuredata.com/sh/install-debian-wheezy-td-agent2.sh | sh
    fi
    
    # Debian 6 (Squeeze) - No SSL Supported
    if [ "${DIST}" = "squeeze" ]; then
        echo 'Installing Fluentd td-agent from http://toolbelt.treasuredata.com/sh/install-debian-squeeze-td-agent2.sh'
        curl -L http://toolbelt.treasuredata.com/sh/install-debian-squeeze-td-agent2.sh | sh
    fi
    
fi

# Start and set td-agent to run on boot
systemctl start td-agent
systemctl enable td-agent
