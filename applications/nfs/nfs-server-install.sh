

# Install NFS package and create directory for mount point
yum install -y nfs-utils

# Create directory
mkdir /nfsshare

# Configure Firewall Ports
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload
