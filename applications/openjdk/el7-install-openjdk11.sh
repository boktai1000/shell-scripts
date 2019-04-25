#!/bin/bash

# https://www.server-world.info/en/note?os=CentOS_7&p=jdk11&f=2
# https://openjdk.java.net/install/
# https://www.reddit.com/r/linuxquestions/comments/avja5n/reloading_current_bash_shell_from_script_thats/

# You can run this script directly with either of the following commands
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/el7-install-openjdk11.sh)
# source <(curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openjdk/el7-install-openjdk11.sh)

# Download OpenJDK 11
(cd /tmp && curl -O https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz)

# Un-tar OpenJDK 11 to installation location
tar zxvf /tmp/openjdk-11.0.2_linux-x64_bin.tar.gz -C /usr/local/

# Cleanup downloaded tar file
rm -f /tmp/openjdk-11.0.2_linux-x64_bin.tar.gz

# Create jdk.sh file that will set variables when users login to system
echo export JAVA_HOME=/usr/local/jdk-11.0.2 | sudo tee /etc/profile.d/jdk11.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/jdk11.sh

# Load the script now so variables are set
. /etc/profile.d/jdk11.sh

# Validate and show current Java version
java -version
