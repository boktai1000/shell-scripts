# Run
# curl

# Set variable for you to specify directory
NFS_SHARE_DIR=$1

# Create directory
mkdir $NFS_SHARE_DIR

# Set permissions on NFS directory
chmod -R 755 $NFS_SHARE_DIR
chown nfsnobody:nfsnobody $NFS_SHARE_DIR

# Add directory to exports for sharing
echo "$NFS_SHARE_DIR    *(rw,sync,no_root_squash,no_all_squash)" | sudo tee -a /etc/exports

# Restart NFS Service
systemctl restart nfs-server
