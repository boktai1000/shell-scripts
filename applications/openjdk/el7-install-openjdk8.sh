#!/bin/bash

# https://openjdk.java.net/install/
# https://www.digitalocean.com/community/tutorials/how-to-install-java-on-centos-and-fedora#install-openjdk-8

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/el7-install-openjdk8.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/openjdk/el7-install-openjdk8.sh | sudo bash

# Install OpenJDK 8 from Repos
sudo yum install java-1.8.0-openjdk -y
