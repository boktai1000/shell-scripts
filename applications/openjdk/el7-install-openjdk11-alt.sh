#!/bin/bash

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/el7-install-openjdk11-alt.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openjdk/el7-install-openjdk11-alt.sh | sudo bash

# Download OpenJDK 11
(cd /tmp && curl -O https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz)

# Un-tar OpenJDK 11 to installation location
tar zxvf /tmp/openjdk-11.0.2_linux-x64_bin.tar.gz -C /usr/local/

# Cleanup downloaded tar file
rm -f /tmp/openjdk-11.0.2_linux-x64_bin.tar.gz

# Configure alternatives to use OpenJDK 11
alternatives --install /usr/bin/java java /usr/local/jdk-11.0.2/bin/java 1000
alternatives --set java /usr/local/jdk-11.0.2/bin/java
