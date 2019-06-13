#!/usr/bin/env bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/terraform/nix-install-terraform.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/terraform/nix-install-terraform.sh | sudo bash

# Set variables
TERRAFORM_VERSION=${1:-0.11.11}
TERRAFORM_FILENAME=terraform_$TERRAFORM_VERSION_linux_amd64.zip
TERRAFORM_DOWNLOAD_ADDRESS=https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_FILENAME

# Install Unzip
sudo apt-get install unzip -y

# Download latest version of the terraform
(cd /tmp && curl -O $TERRAFORM_DOWNLOAD_ADDRESS)

# Extract the downloaded file archive
unzip /tmp/$TERRAFORM_FILENAME

# Move the executable into a directory searched for executables
sudo mv /tmp/terraform /usr/local/bin/

# Run it
terraform --version
