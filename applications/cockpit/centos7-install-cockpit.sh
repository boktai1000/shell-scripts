# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/cockpit/centos7-install-cockpit.sh | sudo bash

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')

# Install cockpit
yum -y install cockpit sos

# Enable cockpit
systemctl enable --now cockpit.socket

# Configure firewall
firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload

# Echo a reminder to CLI on how to login to Cockpit
echo Login to Cockpit at https://$yourip:9090
