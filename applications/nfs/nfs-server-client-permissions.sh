

# Configure Server to allow Clients to connect
echo "/nfsshare $1(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
