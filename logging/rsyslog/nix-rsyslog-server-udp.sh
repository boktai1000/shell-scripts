#!/bin/bash

# https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/
# https://www.ostechnix.com/setup-centralized-rsyslog-server-centos-7/

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/logging/rsyslog/nix-rsyslog-server-udp.sh | sudo bash

# Backup /etc/rsyslog.conf
cp /etc/rsyslog.conf /etc/rsyslog.conf.bak-"$(date --utc +%FT%T.%3NZ)"

# Red Hat like specific commands and variables - only tested on CentOS
if [ -f /etc/redhat-release ]; then
    
    # Configure Rsyslog to accept remote log messages using UDP port 514
    sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
    sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf
    
    systemctl restart rsyslog
    
    # Opening Firewall port 514 UDP for Rsyslog
    echo 'Opening Firewall port 514 UDP for Rsyslog'
    firewall-cmd --add-port=514/udp > /dev/null
    firewall-cmd --permanent --add-port=514/udp > /dev/null
    
fi

# Debian like specific commands and variables - only tested on Ubuntu
if [ -f /etc/debian_version ]; then
    debianID=$(lsb_release -is)
    DIST="$(lsb_release -cs)"
    
    # Ubuntu
    if [ "${debianID}" = "Ubuntu" ]; then
        
        # Configure Rsyslog to accept remote log messages using UDP port 514
        sed -i 's/#module(load="imudp")/module(load="imudp")/g' /etc/rsyslog.conf
        sed -i 's/#input(type="imudp" port="514")/input(type="imudp" port="514")/g' /etc/rsyslog.conf
        
        systemctl restart rsyslog
        
        # Opening Firewall port 514 UDP for Rsyslog
        echo 'Opening Firewall port 514 UDP for Rsyslog'
        ufw allow 514/udp > /dev/null
        
        ufw reload
        
    fi
    
    # Debian 9 (stretch)
    if [ "${DIST}" = "stretch" ]; then
        
        # Configure Rsyslog to accept remote log messages using UDP port 514
        sed -i 's/#module(load="imudp")/module(load="imudp")/g' /etc/rsyslog.conf
        sed -i 's/#input(type="imudp" port="514")/input(type="imudp" port="514")/g' /etc/rsyslog.conf
        
        systemctl restart rsyslog
        
        # Opening Firewall port 514 UDP for Rsyslog
        echo 'Opening Firewall port 514 UDP for Rsyslog'
        iptables -I INPUT -m state --state NEW -m udp -p udp --dport 514 -j ACCEPT
        
    fi
    
    # Debian 8 (Jessie)
    if [ "${DIST}" = "jessie" ]; then
        
        # Configure Rsyslog to accept remote log messages using UDP port 514
        sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
        sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf
        
        systemctl restart rsyslog
        
        # Opening Firewall port 514 UDP for Rsyslog
        echo 'Opening Firewall port 514 UDP for Rsyslog'
        iptables -I INPUT -m state --state NEW -m udp -p udp --dport 514 -j ACCEPT
        
    fi
fi
