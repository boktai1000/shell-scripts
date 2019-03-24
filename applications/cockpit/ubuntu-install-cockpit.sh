# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/cockpit/ubuntu-install-cockpit.sh | sudo bash

# Install Cockpit
sudo apt-get install -y cockpit

# Echo a reminder to CLI on how to login
echo Login at your IP Address:
hostname -I | awk '{print $1}'
echo Default port: tcp/9090
