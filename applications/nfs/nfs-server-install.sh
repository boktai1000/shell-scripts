
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/nfs/nfs-server-install.sh | sudo bash

# Install NFS package and create directory for mount point
yum install -y nfs-utils

# Create directory
mkdir /nfsshare

# Configure Firewall Ports
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload
