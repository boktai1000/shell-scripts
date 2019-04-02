# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/bash/alt/red-white_shell-alt.sh)

# Color via https://askubuntu.com/a/549150 (Server root)
sudo tee /etc/profile.d/red-white_shell-alt.sh <<EOF
export PS1="\[\e[01;37m\][\[\e[0m\]\[\e[01;31m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[01;34m\]\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;37m\]\t\[\e[0m\]\[\e[01;37m\] \W]\$ \[\e[0m\]"
EOF

# Load new bash settings
. /etc/profile.d/red-white_shell-alt.sh
