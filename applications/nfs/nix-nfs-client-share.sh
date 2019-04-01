# You can run this script directly with the following command
# Append your Server IP followed by the NFS directory you want to mount for example "| sudo bash -s 192.168.1.1 /var/nfsshare"
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/nfs/nix-nfs-client-share.sh | sudo bash -s 

# Set variables
NFS_SERVER_IP=$1
NFS_SHARE_DIR=$2

# Create directory on filesystem where you will mount to
mkdir -p /mnt/nfs$NFS_SHARE_DIR

# Add to fstab so mounted directory persists on reboot
echo "$NFS_SERVER_IP:$NFS_SHARE_DIR    /mnt/nfs$NFS_SHARE_DIR   nfs defaults 0 0" | sudo tee -a /etc/fstab

# Attempt to mount new directory from fstab
mount -a

# Test the mount point
touch /mnt/nfs$NFS_SHARE_DIR/test_nfs
