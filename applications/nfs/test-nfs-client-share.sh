# You can run this script directly with the following command
# Append your Server IP followed by the NFS directory you want to mount for example "| sudo bash -s 192.168.1.1 /var/nfsshare"
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/nfs/test-nfs-client-share.sh | sudo bash -s 

# Install NFS Packages
yum install -y nfs-utils

# Set variables
NFS_SERVER=$1
NFS_SHARE=$2

# Display all servers mount points to CLI
showmount -e $NFS_SERVER

# Create directory on filesystem where you will mount to
mkdir -p /mnt/nfs$NFS_SHARE

# Add to fstab so mounted directory persists on reboot
echo "$NFS_SERVER:$NFS_SHARE    /mnt/nfs$NFS_SHARE   nfs defaults 0 0" | sudo tee -a /etc/fstab

# Attempt to mount new directory from CLI - Alternative to fstab mount, not persistent
# mount $NFS_SERVER:$NFS_SHARE /mnt/nfs$NFS_SHARE

# Attempt to mount new directory from fstab
mount -a

# Validation: Display file system mounted partitions with filesystem type
df -hT

# Validation: Display mounted partitions
mount | grep nfs

# Validation: Test the mount point
touch /mnt/nfs$NFS_SHARE/test_nfs
