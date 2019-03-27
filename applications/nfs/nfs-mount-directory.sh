

# Temporarily mount directory
# mount -t nfs $1:/nfsshare /mnt/nfsshare

# Add mount point to fstab so it is permanent
echo "$1:/nfsshare /mnt  nfs defaults 0 0" | sudo tee -a /etc/fstab

# Attempt to mount new volumes from fstab
mount -a
