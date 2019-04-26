#!/bin/bash

# https://github.com/shyiko/jabba
# https://github.com/shyiko/jabba/blob/master/index.json
# https://jdk.java.net/

# You can run this script directly with either of the following commands
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/nix-jabba-openjdk12.sh)
# source <(curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openjdk/nix-jabba-openjdk12.sh)

# Install Jabba
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh

# Install OpenJDK 12 (Latest)
jabba install openjdk@1.12.0
