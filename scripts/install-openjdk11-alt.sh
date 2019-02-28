# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/install-openjdk11-alt.sh | sudo bash

cd /tmp
curl -O https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz

tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz
sudo mv jdk-11.0.2/ /usr/local/

alternatives --install /usr/bin/java java /usr/local/jdk-11.0.2/bin/java 1000
alternatives --set java /usr/local/jdk-11.0.2/bin/java
