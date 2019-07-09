#!/bin/bash

# https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/

# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/testing/nix-tomcat-sample.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/testing/nix-tomcat-sample.sh | sudo bash

# Download sample.war to /tmp
(cd /tmp && curl -O https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war)

# Copy sample.war to Tomcat webapps
cp /tmp/sample.war /opt/tomcat/webapps

# Remove sample.war from /tmp
rm /tmp/sample.war
