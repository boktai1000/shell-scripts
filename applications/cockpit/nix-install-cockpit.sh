#!/usr/bin/env bash

# https://cockpit-project.org/running.html
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
    rhelID=$(awk '{print $1}' < /etc/redhat-release)
    
    # Cockpit is included in the RHEL Extras repository in versions 7.1 and later
    if [ "${rhelID}" = "Red" ]; then
        
        # Enable the Extras repository
        subscription-manager repos --enable rhel-7-server-extras-rpms
        
        # Install Cockpit
        yum -y install cockpit
        
        # Enable Cockpit
        systemctl enable --now cockpit.socket
        
        # Configure firewall
        firewall-cmd --add-service=cockpit
        firewall-cmd --add-service=cockpit --permanent
        
    fi
    
    # Cockpit is included in CentOS 7.x
    if [ "${rhelID}" = "CentOS" ]; then
        
        # Install Cockpit
        yum -y install cockpit setroubleshoot-server sos
        
        # Enable Cockpit
        systemctl enable --now cockpit.socket
        
        # Configure firewall
        firewall-cmd --permanent --zone=public --add-service=cockpit
        firewall-cmd --reload
        
    fi
fi

if [ -f /etc/debian_version ]; then
    debianID=$(lsb_release -is)
    
    # Ubuntu 17.04 and later
    if [ "${debianID}" = "Ubuntu" ]; then
        
        # Install Cockpit
        apt-get install -y cockpit
        
    fi
    
    if [ "${debianID}" = "Debian" ]; then
        DIST="$(lsb_release -cs)"
        
        # Debian 9 (Stretch)
        if [ "${DIST}" = "stretch" ]; then
            
            # Enable the backports repository:
            echo 'deb http://deb.debian.org/debian stretch-backports main' > \
            /etc/apt/sources.list.d/backports.list
            apt-get update
            
            # Install Cockpit
            apt-get install -y cockpit
            
        fi
        
        # Debian 8 (Jessie)
        if [ "${DIST}" = "jessie" ]; then
            
            # Enable the backports-sloppy repository:
            echo 'deb http://deb.debian.org/debian jessie-backports-sloppy main' > \
            /etc/apt/sources.list.d/backports.list
            apt-get update
            
            # Install Cockpit
            apt-get install -y cockpit
            
        fi
    fi
fi

# Echo a reminder to CLI on how to login to Cockpit
echo Login to Cockpit at https://"$yourip":9090
