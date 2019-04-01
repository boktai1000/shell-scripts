# You can run this script directly with the following command
# Append your Client allowed IP Range followed by the NFS directory you want to create for example "| sudo bash -s 192.168.1.1 /var/nfsshare"
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/nfs/nix-nfs-server.sh | sudo bash -s 

# Set variable for you to specify directory
NFS_CLIENT_IP=$1
NFS_SHARE_DIR=$2

# Create directory
mkdir $NFS_SHARE_DIR

# Set permissions on NFS directory
chmod -R 755 $NFS_SHARE_DIR
chown nfsnobody:nfsnobody $NFS_SHARE_DIR

# Add directory to exports for sharing
echo "$NFS_SHARE_DIR    $NFS_CLIENT_IP(rw,sync,no_root_squash,no_all_squash)" | sudo tee -a /etc/exports

# Restart NFS Service
systemctl restart nfs-server
