#!/bin/bash

# https://www.logicmonitor.com/support/monitoring/os-virtualization/snmp-ntp-configuration-for-linux-devices/
# https://www.certdepot.net/rhel7-install-snmp/
# https://stackoverflow.com/questions/6482377/check-existence-of-input-argument-in-a-bash-shell-script

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/snmp/nix-install-snmpd.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/security/snmp/nix-install-snmpd.sh | sudo bash

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
    echo 'Opening Firewall port 161 UDP for SNMP'
    firewall-cmd --add-port=161/udp > /dev/null
    firewall-cmd --permanent --add-port=161/udp > /dev/null
fi

# Debian like specific commands and variables - only tested on Ubuntu
if [ -f /etc/lsb-release ]; then
    
    # Install SNMP and optional snmpwalk tools
    apt-get install -y snmpd
    
    # Open Firewall for SNMP monitoring
    echo 'Opening Firewall port 161 UDP for SNMP'
    ufw allow 161/udp > /dev/null
    ufw reload
fi

# Create a backup copy of the distros SNMP config file
cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak-"$(date --utc +%FT%T.%3NZ)"

# Define new SNMP settings
echo "rocommunity $SNMP_COMMUNITY" > /etc/snmp/snmpd.conf

# Add syslocation only if argument given
if [ -z "$2" ]
then
    echo "No SNMP syslocation value given - continuing without it"
else
    echo "syslocation $SNMP_SYSLOCATION" >> /etc/snmp/snmpd.conf
fi

# Add syscontact only if argument given
if [ -z "$3" ]
then
    echo "No SNMP syscontact value given - continuing without it"
else
    echo "syscontact $SNMP_SYSCONTACT" >> /etc/snmp/snmpd.conf
fi

# Show file contents of /etc/snmp/snmpd.conf
cat /etc/snmp/snmpd.conf

# Start the daemon, and set it to start on server boot. For RedHat/CentOS 7.0 you can use these systemctl commands:
systemctl restart snmpd.service
systemctl enable snmpd.service
