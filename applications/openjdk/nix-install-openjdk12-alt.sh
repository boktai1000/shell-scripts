#!/bin/bash

# https://www.server-world.info/en/note?os=CentOS_7&p=jdk11&f=2
# https://openjdk.java.net/install/
# https://www.reddit.com/r/linuxquestions/comments/avja5n/reloading_current_bash_shell_from_script_thats/
# https://computingforgeeks.com/how-to-install-java-12-on-centos-fedora/

# You can run this script directly with either of the following commands
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/nix-install-openjdk12-alt.sh)
# source <(curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openjdk/nix-install-openjdk12-alt.sh)

# Set variables - Optionally specify install directory or default to /opt
JAVA_DIR="${1-/opt}"

# Download OpenJDK
(cd /tmp && curl -O https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz)

# Un-tar OpenJDK to installation location
tar zxvf /tmp/openjdk-12.0.1_linux-x64_bin.tar.gz -C "$JAVA_DIR"/

# Cleanup downloaded tar file
rm -f /tmp/openjdk-12.0.1_linux-x64_bin.tar.gz

# Configure alternatives to use OpenJDK
alternatives --install /usr/bin/java java /opt/jdk-12.0.1/bin/java 1000
alternatives --set java /opt/jdk-12.0.1/bin/java
