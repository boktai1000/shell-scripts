#!/bin/bash
# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/customization/bash/nix-bash_gold-silver.sh)

# http://bashrcgenerator.com/
# https://askubuntu.com/a/549150
# https://serverfault.com/a/506267/480927
# https://www.reddit.com/r/linux/comments/2uf5uu/this_is_my_bash_prompt_which_is_your_favorite/?depth=2
sudo bash -c 'cat > /etc/profile.d/fancy-bash-prompt.sh' <<\EOF
#!/bin/bash

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    if [[ "${EUID}" -eq 0 ]]; then
        export PS1="[\[$(tput sgr0)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;244m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \T \W]\\$ \[$(tput sgr0)\]"
    else
        export PS1="[\[$(tput sgr0)\]\[\033[38;5;220m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;244m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \T \W]\\$ \[$(tput sgr0)\]"
    fi
else
    if [[ "${EUID}" -eq 0 ]]; then
        export PS1="\[\e[01;37m\][\[\e[0m\]\[\e[01;31m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[01;34m\]\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;37m\]\t\[\e[0m\]\[\e[01;37m\] \W]\\$ \[\e[0m\]"
    else
        export PS1="\[\e[01;37m\][\[\e[0m\]\[\e[01;32m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[01;34m\]\h\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;37m\]\t\[\e[0m\]\[\e[01;37m\] \W]\\$ \[\e[0m\]"
    fi
fi
EOF

# Load new bash settings
. /etc/profile.d/fancy-bash-prompt.sh
