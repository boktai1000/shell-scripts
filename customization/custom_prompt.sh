# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/custom_prompt.sh | sudo bash

cat << EOF > /etc/profile.d/custom_prompt.sh
export PS1="\[\e[01;37m\][\[\e[0m\]\[\e[01;31m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[01;34m\]\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;37m\]\t\[\e[0m\]\[\e[01;37m\] \W]\\$ \[\e[0m\]"
EOF
