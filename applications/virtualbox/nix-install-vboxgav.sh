#!/bin/bash

# https://gist.github.com/jonasschultzmblox/f15fe3c10769d5f269635a54394c84d4#gistcomment-2023609
# https://gist.github.com/dirtmerchant/a32007dc2980bbccda3de0873e28340e
# https://www.tecmint.com/install-virtualbox-guest-additions-in-ubuntu/
# https://askubuntu.com/questions/22743/how-do-i-install-guest-additions-in-a-virtualbox-vm

# Append your version number after "| sudo bash -s" ; Example- "| sudo bash -s 6.0.4"
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/virtualbox/nix-install-vboxgav.sh | sudo bash -s
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/virtualbox/nix-install-vboxgav.sh | sudo bash -s

# Set VirtualBox Variable so argument from command line gets passed through
VBOX_VERSION=$1

# Red Hat like specific commands and variables - only tested on CentOS
if [ -f /etc/redhat-release ]; then
    
    ARCH=$(uname -r |cut -f7 -d.)
    KVER=$(uname -r |cut -f1-6 -d.)
    
    # Install prereqs - install matching kernel tools and headers
    yum install -y bzip2 gcc kernel-devel-"${KVER}"."${ARCH}"
    
fi

# Debian like specific commands and variables - only tested on Ubuntu
if [ -f /etc/lsb-release ]; then
    
    KVER=$(uname -r)
    
    # Install prereqs - install matching kernel tools and headers
    apt install -y build-essential dkms linux-headers-"${KVER}"
    
fi

# Download VboxGuestAdditions
echo Downloading http://download.virtualbox.org/virtualbox/"$VBOX_VERSION"/VBoxGuestAdditions_"$VBOX_VERSION".iso
(cd /tmp && curl -O http://download.virtualbox.org/virtualbox/"$VBOX_VERSION"/VBoxGuestAdditions_"$VBOX_VERSION".iso)

# Mount and run iso
mount -o loop,ro /tmp/VBoxGuestAdditions_"$VBOX_VERSION".iso /mnt
sh /mnt/VBoxLinuxAdditions.run

# Cleanup
umount /mnt
rm /tmp/VBoxGuestAdditions_"$VBOX_VERSION".iso
