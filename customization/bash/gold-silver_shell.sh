# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/bash/gold-silver_shell.sh)

# Color via http://bashrcgenerator.com/ (Custom)
sudo bash -c 'cat > /etc/profile.d/gold-silver_shell.sh' << EOF
export PS1="[\[\]\[\033[38;5;220m\]\u\[\]\[\033[38;5;15m\]@\[\]\[\033[38;5;249m\]\h\[\]\[\033[38;5;15m\] \T \W]\$ \[\]"
EOF

# Refresh Profile
. /etc/profile
