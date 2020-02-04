#!/bin/bash

# https://www.server-world.info/en/note?os=CentOS_7&p=jdk11&f=2
# https://openjdk.java.net/install/
# https://www.reddit.com/r/linuxquestions/comments/avja5n/reloading_current_bash_shell_from_script_thats/
# https://computingforgeeks.com/how-to-install-java-12-on-centos-fedora/

# You can run this script directly with either of the following commands
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/nix-install-openjdk12.sh)
# source <(curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openjdk/nix-install-openjdk12.sh)

# Set variables - Optionally specify install directory or default to /opt
JAVA_DIR="${1-/opt}"

# Script must be run as root, but this block currently kills your terminal - need to find a better solution later
if [ "$EUID" -ne "0" ]; then
    echo "This script must be run as root." >&2
    return 1
fi

# Download OpenJDK
(cd /tmp && curl -O https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz)

# Un-tar OpenJDK to installation location
tar zxvf /tmp/openjdk-13.0.2_linux-x64_bin.tar.gz -C "$JAVA_DIR"/

# Cleanup downloaded tar file
rm -f /tmp/openjdk-13.0.2_linux-x64_bin.tar.gz

# Create jdk.sh file that will set variables when users login to system
echo export JAVA_HOME="$JAVA_DIR"/jdk-13.0.2 | sudo tee /etc/profile.d/jdk13.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/jdk13.sh

# Load the script now so variables are set
. /etc/profile.d/jdk13.sh

# Validate and show current Java version
java -version
