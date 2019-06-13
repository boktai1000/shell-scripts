#!/usr/bin/env bash

# https://askubuntu.com/questions/983351/how-to-install-terraform-in-ubuntu
# https://askubuntu.com/questions/520546/how-to-extract-a-zip-file-to-a-specific-folder
# https://superuser.com/questions/100656/linux-unzip-command-option-to-force-overwrite
# http://www.codebind.com/linux-tutorials/unzip-zip-file-using-terminal-linux-ubuntu-linux-mint-debian/
# https://releases.hashicorp.com/terraform/

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/terraform/nix-install-terraform.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/terraform/nix-install-terraform.sh | sudo bash

# Set variables (Note: default version of 0.11.11)
TERRAFORM_VERSION=${1:-0.11.11}
TERRAFORM_FILENAME=terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
TERRAFORM_DOWNLOAD_ADDRESS=https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_FILENAME

# Check for Red Hat-based distro
if [ -f /etc/redhat-release ]; then
    
    # Install Unzip
    yum install unzip -y
    
fi

# Check for Debian-based distro
if [ -f /etc/debian_version ]; then
    
    # Install Unzip
    apt-get install unzip -y
    
fi

# Download latest version of the terraform
echo "Downloading: $TERRAFORM_DOWNLOAD_ADDRESS..."
(cd /tmp && curl -O "$TERRAFORM_DOWNLOAD_ADDRESS")

# Extract the downloaded file archive
unzip -o /tmp/"$TERRAFORM_FILENAME" -d /usr/local/bin/

# Run it
terraform --version
