# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/bash/blue-grey_shell.sh | sudo bash

# Color via http://bashrcgenerator.com/ (Custom)
cat << EOF > /etc/profile.d/blue-grey_shell.sh
export PS1="[\[$(tput sgr0)\]\[\033[38;5;39m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;249m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \T \W]\\$ \[$(tput sgr0)\]"
EOF
