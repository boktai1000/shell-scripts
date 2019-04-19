#!/usr/bin/env bash

# https://gist.github.com/dirtmerchant/a32007dc2980bbccda3de0873e28340e
# https://gist.github.com/christronyxyocum/f10bf4f942e99ae00e18a497aad595a8

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/cockpit/nix-install-cockpit.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/cockpit/nix-install-cockpit.sh | sudo bash

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')

if [ "$EUID" -ne "0" ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

if [ -f /etc/redhat-release ]; then
    
    rhelID=$(cat /etc/redhat-release |awk '{print $1}')
    
    if [ "${rhelID}" = "Red" ]; then
        
        # Enable the Extras repository:
        subscription-manager repos --enable rhel-7-server-extras-rpms
        
        # Install cockpit:
        yum install cockpit
        
        # Enable cockpit:
        systemctl enable --now cockpit.socket
        
        # Open the firewall if necessary:
        sudo firewall-cmd --add-service=cockpit
        sudo firewall-cmd --add-service=cockpit --permanent
        
    fi
    
    if [ "${rhelID}" = "CentOS" ]; then
        
        # Install cockpit
        yum -y install cockpit setroubleshoot-server sos
        
        # Enable cockpit
        systemctl enable --now cockpit.socket
        
        # Configure firewall
        firewall-cmd --permanent --zone=public --add-service=cockpit
        firewall-cmd --reload
        
    fi
    
fi

if [ -f /etc/debian_version ]; then
    
    debianID=$(cat /etc/os-release |egrep -vi 'pretty|code' |grep -i name |cut -c6-50 |tr -d '"' |awk '{print $1}')
    
    if [ "${debianID}" = "Ubuntu" ]; then
        
        # Install Cockpit
        sudo apt-get install -y cockpit
        
    fi
    
    if [ "${debianID}" = "Debian" ]; then
        DIST="$(cat /etc/os-release |grep -i name |grep -i pretty |cut -c14-50 |tr -d '"')"
        
        if [ "${DIST}" = "Debian GNU/Linux 9 (stretch)" ]; then
            
            # For Debian 9 you have to enable the backports repository:
            echo 'deb http://deb.debian.org/debian stretch-backports main' > \
            /etc/apt/sources.list.d/backports.list
            apt-get update
            
        fi
        
        #Install the package:
        apt-get install cockpit
        
    fi
    
fi

# Echo a reminder to CLI on how to login to Cockpit
echo Login to Cockpit at https://"$yourip":9090
