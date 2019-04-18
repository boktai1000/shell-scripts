#!/bin/bash

# https://github.com/shyiko/jabba
# https://github.com/shyiko/jabba/blob/master/index.json
# https://jdk.java.net/ 

# Install Jabba
curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh

# Install OpenJDK 12
jabba install openjdk@1.12.0-1
