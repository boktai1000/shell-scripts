#!/bin/bash

# Append your version number after "| sudo bash -s" ; Example- "| sudo bash -s 6.0.4"
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/virtualbox/el7-install-vboxgav.sh | sudo bash -s 
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/virtualbox/el7-install-vboxgav.sh | sudo bash -s 

# Set VirtualBox Variable so argument from command line gets passed through
# https://gist.github.com/jonasschultzmblox/f15fe3c10769d5f269635a54394c84d4#gistcomment-2023609
VBOX_VERSION=$1
ARCH=`uname -r |cut -f7 -d.`
KVER=`uname -r |cut -f1-6 -d.`

# Install prereqs - install matching kernel tools and headers
yum install -y bzip2 gcc kernel-devel-"${KVER}"."${ARCH}"

# Change to temp directory and download VboxGuestAdditions
cd /tmp || exit
curl -O http://download.virtualbox.org/virtualbox/"$VBOX_VERSION"/VBoxGuestAdditions_"$VBOX_VERSION".iso

# Mount and run iso
mount -o loop,ro VBoxGuestAdditions_"$VBOX_VERSION".iso /mnt
sh /mnt/VBoxLinuxAdditions.run

# Cleanup
umount /mnt
rm /tmp/VBoxGuestAdditions_"$VBOX_VERSION".iso
