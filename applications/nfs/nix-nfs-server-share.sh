# You can run this script directly with the following command
# Append your Client allowed IP Range followed by the NFS directory you want to create for example "| sudo bash -s 192.168.1.1 /var/nfsshare"
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/nfs/nix-nfs-server-share.sh | sudo bash -s 

# Set variable for you to specify directory
NFS_CLIENT=$1
NFS_SHARE=$2

# Create directory
mkdir $NFS_SHARE

# Set permissions on NFS directory
chmod -R 755 $NFS_SHARE
chown nfsnobody:nfsnobody $NFS_SHARE

# Add directory to exports for sharing
echo "$NFS_SHARE    $NFS_CLIENT(rw,sync,no_root_squash,no_all_squash)" | sudo tee -a /etc/exports

# Restart NFS Service
systemctl restart nfs-server
