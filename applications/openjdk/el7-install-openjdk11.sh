# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/openjdk/el7-install-openjdk11.sh)

cd /tmp
curl -O https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz

tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz
sudo mv jdk-11.0.2/ /usr/local/

rm -f /tmp/openjdk-11.0.2_linux-x64_bin.tar.gz
cd

echo export JAVA_HOME=/usr/local/jdk-11.0.2 | sudo tee /etc/profile.d/jdk11.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' | sudo tee -a /etc/profile.d/jdk11.sh

. /etc/profile.d/jdk11.sh
java -version
