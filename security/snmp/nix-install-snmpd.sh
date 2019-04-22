#!/bin/bash

# https://www.logicmonitor.com/support/monitoring/os-virtualization/snmp-ntp-configuration-for-linux-devices/
# https://www.certdepot.net/rhel7-install-snmp/

# Default SNMP Community of "public"
# If you'd like to limit to an IP/Range put your first argument in quotes followed by the IP/Range (Ex: "public 10.0.0.0/8")
SNMP_COMMUNITY=${1:-public}
SNMP_SYSLOCATION=$2
SNMP_SYSCONTACT=$3

# Red Hat like specific commands and variables - only tested on CentOS
if [ -f /etc/redhat-release ]; then
    
    # Install SNMP and optional snmpwalk tools
    yum install -y net-snmp net-snmp-utils
    
    # Open Firewall for SNMP monitoring
    firewall-cmd --permanent --add-port=161/udp
    firewall-cmd --reload
fi

# Debian like specific commands and variables - only tested on Ubuntu
if [ -f /etc/lsb-release ]; then
    
    # Install SNMP and optional snmpwalk tools
    apt-get install -y snmpd
fi

# Create a backup copy of the distros SNMP config file
cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak

# Define new SNMP settings
echo "rocommunity $SNMP_COMMUNITY" > /etc/snmp/snmpd.conf
echo "syslocation $SNMP_SYSLOCATION" >> /etc/snmp/snmpd.conf
echo "syscontact $SNMP_SYSCONTACT" >> /etc/snmp/snmpd.conf

# Show file contents of /etc/snmp/snmpd.conf
cat /etc/snmp/snmpd.conf

# Start the daemon, and set it to start on server boot. For RedHat/CentOS 7.0 you can use these systemctl commands:
systemctl restart snmpd.service
systemctl enable snmpd.service
