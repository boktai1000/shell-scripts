# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/bash/gold-silver_shell.sh | sudo bash

# Color via http://bashrcgenerator.com/ (Custom)
sudo bash -c 'cat > /etc/profile.d/gold-silver_shell.sh' << EOF
export PS1="[\[$(tput sgr0)\]\[\033[38;5;220m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;249m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \T \W]\\$ \[$(tput sgr0)\]"
EOF
