# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/bash/blue-grey_shell.sh)

# Color via http://bashrcgenerator.com/ (Keegan Custom)
sudo bash -c 'cat > /etc/profile.d/blue-grey_shell.sh' << EOF
export PS1="[\[\]\[\033[38;5;39m\]\u\[\]\[\033[38;5;15m\]@\[\]\[\033[38;5;249m\]\h\[\]\[\033[38;5;15m\] \T \W]\$ \[\]"
EOF

# Load new bash settings
. /etc/profile.d/blue-grey_shell.sh
