#!/bin/bash

# https://www.lisenet.com/2017/centos-7-server-hardening-guide/

# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/ctrl-alt-del/nix-disable-rebootact.sh | sudo bash

# Disable ctrl+alt+del from rebooting system from CLI
systemctl mask ctrl-alt-del.target
