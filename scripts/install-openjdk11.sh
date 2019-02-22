curl -O https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz

tar zxvf openjdk-11.0.2_linux-x64_bin.tar.gz
sudo mv jdk-11.0.2/ /usr/local/

echo export JAVA_HOME=/usr/local/jdk-11.0.2 >> /etc/profile.d/jdk11.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile.d/jdk11.sh

source /etc/profile.d/jdk11.sh
java -version
