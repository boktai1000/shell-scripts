# https://linuxize.com/post/how-to-install-jenkins-on-centos-7/
# https://www.vultr.com/docs/how-to-install-jenkins-on-centos-7

# Install Java (OpenJDK 11+ apparently doesn't work)
sudo yum install java-1.8.0-openjdk.x86_64

# Check and Validate Java Version
java -version

# Set Java Variables
sudo cp /etc/profile /etc/profile_backup
echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
source /etc/profile

# Check and validate variables
echo $JAVA_HOME
echo $JRE_HOME

# Install Jenkins
cd /etc/yum.repos.d/;curl -O https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins

# Start Jenkins
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service

# Open Firewall
sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
