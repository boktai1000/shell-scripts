# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/openssh/openssh-old-compatibility.sh | sudo bash

# https://community.cisco.com/t5/unified-communications/cucm-sftp-backup-to-linux-fail/td-p/2805926
# http://cdesigner.eu/content/14-cucm-8-free-sftp-solution-backup-ubuntu-1004-server
# https://community.cisco.com/t5/ip-telephony-and-phones/cucm-backup-with-openssh/td-p/2611429

# Backup files before continuing
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Define ciphers for SSH configuration file
echo "Ciphers +aes128-cbc" | sudo tee -a /etc/ssh/sshd_config
echo "KexAlgorithms +diffie-hellman-group1-sha1" | sudo tee -a /etc/ssh/sshd_config

# Restart SSH Services
sudo systemctl restart sshd
