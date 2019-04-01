# Append your directory name after the "sudo bash -s"
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/nfs/nfs-mount-directory.sh | sudo bash -s 

# Temporarily mount directory
# mount -t nfs $1:/nfsshare /mnt/nfsshare

# Add mount point to fstab so it is permanent
echo "$1:/nfsshare /mnt  nfs defaults 0 0" | sudo tee -a /etc/fstab

# Attempt to mount new volumes from fstab
mount -a
