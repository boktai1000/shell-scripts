# You can run this script directly with the following command followed by your desired username and then password
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/openssh/openssh-old-user.sh | sudo bash -s 

# https://community.cisco.com/t5/unified-communications/cucm-sftp-backup-to-linux-fail/td-p/2805926
# http://cdesigner.eu/content/14-cucm-8-free-sftp-solution-backup-ubuntu-1004-server
# https://community.cisco.com/t5/ip-telephony-and-phones/cucm-backup-with-openssh/td-p/2611429

# Set variables, first value appended is your desired username, second value is the users password
youruser=$1
yourpass=$2

# Example usernames could be "cucm_8" or "ciscobackup"
sudo adduser $1
echo '$1:$2' | sudo chpasswd
sudo chown root:root /home/$1/
sudo chmod 777 /home/$1/
