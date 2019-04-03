# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/login/el7-login-ip-perl.sh | sudo bash

# Install Perl - required for script
sudo yum install -y perl

# Backup /etc/issue
sudo cp /etc/issue /etc/issue.bak

# Create script and place in /sbin/
sudo tee /sbin/ifup-local <<EOF
#!/bin/sh
PREFIX="Local IP addresses:"
IPADDRS=$(hostname -I | tr " " "\n" | grep -v "^$" | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tr "\n" " ")

perl -i -p -0777 -e "s/^$PREFIX[^\n]*\n\n//m; s/$/\n$PREFIX $IPADDRS\n/ if length('$IPADDRS')>6" /etc/issue
EOF

# Set file executable
sudo chmod +x /sbin/ifup-local

# Copy script for ifdown-local
sudo cp /sbin/ifup-local /sbin/ifdown-local
