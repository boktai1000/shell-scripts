# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/jenkins/el7-install-jenkins-native.sh | sudo bash

# https://www.hugeserver.com/kb/how-install-jenkins-centos7/
# https://www.linuxtechi.com/install-configure-jenkins-on-centos-7-rhel-7/
# https://computingforgeeks.com/how-to-install-jenkins-server-stable-on-centos-7/
# https://www.vultr.com/docs/how-to-install-jenkins-on-centos-7

# Set Variables
yourip=$(hostname -I | awk '{print $1}')

# Add Jenkins Repository
curl https://pkg.jenkins.io/redhat-stable/jenkins.repo > /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Install Java and Jenkins
yum install -y java-1.8.0-openjdk jenkins

# Check and Validate Java Version
java -version

# Start and Enable Jenkins Service
systemctl start jenkins
systemctl enable jenkins
systemctl status jenkins

# Open Firewall
firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

# Echo information on what the output beneath this is for
echo Your Jenkins initial Admin Password

# https://stackoverflow.com/questions/2379829/while-loop-to-test-if-a-file-exists-in-bash
# Wait for file to be created, then Display initial Admin Password
# Alternatively run "grep -A 5 password /var/log/jenkins/jenkins.log"
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]
do
  sleep 2
done
cat /var/lib/jenkins/secrets/initialAdminPassword

# Echo a reminder to CLI on how to connect to Tomcat
echo Connect to Jenkins at http://$yourip:8080 and input your initial Admin Password to continue setup
