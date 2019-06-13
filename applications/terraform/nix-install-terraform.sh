#!/usr/bin/env bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/terraform/nix-install-terraform.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/terraform/nix-install-terraform.sh | sudo bash

# Set Variable for your IP Address
yourip=$(hostname -I | awk '{print $1}')
