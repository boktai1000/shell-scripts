#!/usr/bin/env bash

# http://mscorefonts2.sourceforge.net/
# https://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-install-microsoft-truetype-fonts-in-centos-6-rhel-6.html

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/fonts/nix-install-mscorefonts.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/fonts/nix-install-mscorefonts.sh | sudo bash

if [ "$EUID" -ne "0" ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

if [ -f /etc/redhat-release ]; then
    
    # EPEL Repo Required for cabextract, needs to be installed beforehand
    yum install -y epel-release
    
    # Install tools required for font management
    yum install -y curl cabextract xorg-x11-font-utils fontconfig
    
    # Install MS Core Fonts - requires cabextract
    rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
    
fi

if [ -f /etc/debian_version ]; then
    
    # Install MS Core Fonts
    apt install ttf-mscorefonts-installer
    
fi
