# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/el7-disable-hotkey-reboot.sh | sudo bash

# Disable ctrl+alt+del from rebooting system from CLI
systemctl mask ctrl-alt-del.target
