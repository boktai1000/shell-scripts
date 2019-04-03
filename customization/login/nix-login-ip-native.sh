# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/login/nix-login-ip-native.sh | sudo bash

# Backup /etc/issue
sudo cp /etc/issue /etc/issue.bak

# Append Local IP Address to /etc/issue file
sudo tee -a /etc/issue <<EOF
Local IP addresses: \4

EOF
