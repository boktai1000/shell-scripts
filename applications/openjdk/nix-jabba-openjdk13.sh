#!/bin/bash

# https://github.com/shyiko/jabba
# https://github.com/shyiko/jabba/blob/master/index.json
# https://jdk.java.net/

# You can run this script directly with either of the following commands
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/nix-jabba-openjdk13.sh)
# source <(curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openjdk/nix-jabba-openjdk13.sh)

# Install Jabba
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh

# Install OpenJDK 13
jabba install openjdk@1.13.0-2

# https://github.com/shyiko/jabba#faq
# select jdk
jabba use openjdk@1.13.0-2

sudo update-alternatives --install /usr/bin/java java ${JAVA_HOME%*/}/bin/java 20000
sudo update-alternatives --install /usr/bin/javac javac ${JAVA_HOME%*/}/bin/javac 20000
