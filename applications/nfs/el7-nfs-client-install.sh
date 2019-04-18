#!/bin/bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/nfs/el7-nfs-client-install.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/nfs/el7-nfs-client-install.sh | sudo bash

# Install NFS Packages
yum install -y nfs-utils
