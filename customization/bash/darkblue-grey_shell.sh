# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/bash/darkblue-grey_shell.sh)

# Color via http://bashrcgenerator.com/ (Keegan Custom)
sudo bash -c 'cat > /etc/profile.d/darkblue-grey_shell.sh' << EOF
export PS1="[\[$(tput sgr0)\]\[\033[38;5;33m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;249m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \T \W]\\$ \[$(tput sgr0)\]"
EOF

# Load new bash settings
. /etc/profile.d/darkblue-grey_shell.sh
