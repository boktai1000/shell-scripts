#!/bin/bash

# https://www.server-world.info/en/note?os=CentOS_7&p=jdk11&f=2
# https://openjdk.java.net/install/
# https://www.reddit.com/r/linuxquestions/comments/avja5n/reloading_current_bash_shell_from_script_thats/
# https://computingforgeeks.com/how-to-install-java-12-on-centos-fedora/

# You can run this script directly with either of the following commands
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/nix-install-openjdk12.sh)
# source <(curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openjdk/nix-install-openjdk12.sh)

# Download OpenJDK
(cd /tmp && curl -O https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz)

# Un-tar OpenJDK to installation location
tar zxvf /tmp/openjdk-12.0.1_linux-x64_bin.tar.gz -C /opt/

# Cleanup downloaded tar file
rm -f /tmp/openjdk-12.0.1_linux-x64_bin.tar.gz

# Create jdk.sh file that will set variables when users login to system
echo export JAVA_HOME=/opt/jdk-12.0.1 | sudo tee /etc/profile.d/jdk12.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/jdk12.sh

# Load the script now so variables are set
. /etc/profile.d/jdk12.sh

# Validate and show current Java version
java -version
