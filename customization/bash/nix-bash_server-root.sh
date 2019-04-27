#!/bin/bash
# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/bash/nix-bash_server-root.sh)

# https://askubuntu.com/a/549150
# https://www.reddit.com/r/linux/comments/2uf5uu/this_is_my_bash_prompt_which_is_your_favorite/?depth=2
sudo bash -c 'cat > /etc/profile.d/fancy-bash-prompt.sh' <<\EOF
#!/bin/bash

if [[ "${EUID}" -eq 0 ]]; then
    export PS1="\[\e[01;37m\][\[\e[0m\]\[\e[01;31m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[01;34m\]\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;37m\]\t\[\e[0m\]\[\e[01;37m\] \W]\\$ \[\e[0m\]"
else
    export PS1="\[\e[01;37m\][\[\e[0m\]\[\e[01;32m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[01;34m\]\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;37m\]\t\[\e[0m\]\[\e[01;37m\] \W]\\$ \[\e[0m\]"
fi
EOF

# Load new bash settings
. /etc/profile.d/fancy-bash-prompt.sh
