#!/bin/bash
# You can run this script directly with the following command followed by your desired username and then password
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/openssh/openssh-old-user.sh | sudo bash

# https://community.cisco.com/t5/unified-communications/cucm-sftp-backup-to-linux-fail/td-p/2805926
# http://cdesigner.eu/content/14-cucm-8-free-sftp-solution-backup-ubuntu-1004-server
# https://community.cisco.com/t5/ip-telephony-and-phones/cucm-backup-with-openssh/td-p/2611429

# Ask user for username and password
echo "Please enter username:"
read -r username
echo "Please enter desired password:"
read -r password

# Add user
sudo adduser $username

# Change password
printf "%s:%s\n" "$username" "$password" | sudo chpasswd

# Set permissions and ownership over directory
sudo chown root:root /home/$1/
sudo chmod 777 /home/$1/
