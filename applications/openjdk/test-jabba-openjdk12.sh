#!/bin/bash

# Fail on Error
set -e

# Package Reqs
PKG_NAMES=(
    "jabba"
    "java"
)
PKG_REQS=(
   install_jabba
   install_java
)
PKG_LEN=${#PKG_REQS[@]}


# Some Constants
USER_HOME="/home/$SUDO_USER"
HOME="$USER_HOME"
USER_BASHPROF="$USER_HOME/.bash_profile"
USER_BASHRC="$USER_HOME/.bashrc"

# Debug
IS_DEBUG=true

# Source Utils from Gist
source_utils() {
    printf "Grabbing Bash Install Utils...\n"
    local utils_url="https://git.io/fh5mh"
    source <(curl -sL "$utils_url")
    e_success "Install Utils Loaded"
    sleep 1
}

# Get Root
get_root () {
    e_bold "Please provide your Root password (It will be stored for the remained of the script)"
    read -s -p "[sudo] sudo password for $(whoami): " RPASS
}

# Run as Root
as_user() {
    if [ "$IS_DEBUG" = true ]; then 
        sudo -u "$SUDO_USER" -H bash -c "$@"
    else
        sudo -u "$SUDO_USER" -H bash -c "$@" >/dev/null 2>/dev/null
    fi
}

# Handle Other Package Installs
pkg_install() {
    local pkg_name pkg_install
    pkg_name=${PKG_NAMES[$1]}
    pkg_exec=${PKG_REQS[$1]}

    if type_exists "$pkg_name"; then
        return 1
    else
        if [ "$IS_DEBUG" = true ]; then
            $pkg_exec
        else
            $pkg_exec >/dev/null 2>/dev/null
        fi
    fi   
}

# Load Shell
refresh_shell() {
    source "$USER_BASHRC"
    source "$USER_BASHPROF"
    HOME="$USER_HOME"
}

# Handle Curl Scripts
install_from_curl() {
    local url="$1"
    as_user "curl -fsSL $url | bash"
}

# Install Jabba (Java Version Manager)
install_jabba() {
    local jabba_url
    jabba_url="https://github.com/shyiko/jabba/raw/master/install.sh"
    
    echo ""
    e_bold "Installing Java Version Manager..."
    install_from_curl "https://github.com/shyiko/jabba/raw/master/install.sh"
    as_user ". $USER_HOME/.jabba/jabba.sh"
    # Load Jabba In Current Shell
    [ -s "$USER_HOME/.jabba/jabba.sh" ] && source "$USER_HOME/.jabba/jabba.sh"
    refresh_shell

}

# Install Java 1.8
install_java() {
    as_user "jabba install openjdk@1.12.0-1"
    jabba use openjdk@1.12.0-1

}

# Checks/Installed Script Deps
install_deps() {
    # Install Other Packages
    e_title "Other Packages"
    for i in "${!PKG_REQS[@]}"; do
        local index="$i"
        (pkg_install $i) &
            show_spinner "${bold}Installing ${magenta}${PKG_NAMES[$index]}${reset}"
        e_success "${PKG_NAMES[$index]} installed ($(expr $index + 1)/$PKG_LEN)"
    done
}

# Install
main() {
    source_utils
    trap 'handle_error ${LINENO}' ERR
    clear

    # Intro 
    e_header "WarriorBeatApp Install Script"
    e_warning "This Script is very opinionated and will force yay/rbenv/nvm on you!"
    sleep 1

    # Check if Root
    if ! is_root; then
        e_error "Please run this script as root!"
        exit 1
    fi


    # Install Scripts Deps
    install_deps
    
}

main
