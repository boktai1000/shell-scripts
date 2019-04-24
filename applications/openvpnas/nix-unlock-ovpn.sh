#!/bin/bash


# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openvpnas/nix-unlock-ovpn.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openvpnas/nix-unlock-ovpn.sh | sudo bash

/usr/local/openvpn_as/scripts/confdba -mk vpn.server.lockout_policy.reset_time -v 1;/usr/local/openvpn_as/scripts/sacli start;sleep 2;/usr/local/openvpn_as/scripts/confdba -mk vpn.server.lockout_policy.reset_time -v 900;/usr/local/openvpn_as/scripts/sacli start
