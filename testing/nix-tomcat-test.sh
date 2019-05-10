#!/bin/bash

# Append desired version followed by desired port number - otherwise latest version and default port will be selected
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/testing/nix-tomcat-test.sh | sudo bash -s 
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/testing/nix-tomcat-test.sh | sudo bash -s 

tomcatlatest="$(curl -s https://api.github.com/repos/apache/tomcat/tags | grep '"name"' | head -1 | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")"
tomcatminorversion=${1:-$tomcatlatest}
tomcatmajorversion="$(echo "$tomcatminorversion" | cut -c1-1)"
yourip=$(hostname -I | awk '{print $1}')
tomcatport="${2:-8080}"

echo "Validate your configuration file port: 8080" > /tmp/8080testfile

sed -i "s/8080/$tomcatport/g" /tmp/8080testfile

echo "Your Major Version $tomcatmajorversion"
echo "Your Minor Version $tomcatminorversion"
echo "Your IP address $yourip"
echo "Your Tomcat Port $tomcatport"
echo "Tomcat Latest $tomcatlatest"
echo "Proposed Tomcat download URL" https://archive.apache.org/dist/tomcat/tomcat-"$tomcatmajorversion"/v"$tomcatminorversion"/bin/apache-tomcat-"$tomcatminorversion".tar.gz
cat /tmp/8080testfile

rm /tmp/8080testfile
