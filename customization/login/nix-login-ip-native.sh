# https://stackoverflow.com/a/41592571/10149100
# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/login/nix-login-ip-native.sh | sudo bash

# Backup /etc/issue
sudo cp /etc/issue /etc/issue.bak-"$(date --utc +%FT%T.%3NZ)"

# Append Local IP Address to /etc/issue file
sudo tee -a /etc/issue <<EOF
Local IP addresses: \4

EOF
