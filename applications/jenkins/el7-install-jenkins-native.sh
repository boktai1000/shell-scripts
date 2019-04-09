# https://www.hugeserver.com/kb/how-install-jenkins-centos7/
# https://www.linuxtechi.com/install-configure-jenkins-on-centos-7-rhel-7/
# https://computingforgeeks.com/how-to-install-jenkins-server-stable-on-centos-7/
# https://www.vultr.com/docs/how-to-install-jenkins-on-centos-7

# Add Jenkins Repository
curl https://pkg.jenkins.io/redhat-stable/jenkins.repo > /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Install Java and Jenkins
yum install java-1.8.0-openjdk jenkins

# Check and Validate Java Version
java -version

# Start and Enable Jenkins Service
systemctl start jenkins
systemctl enable jenkins
systemctl status jenkins

# Open Firewall
firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

# Display initial Admin Password
# Alternatively run "grep -A 5 password /var/log/jenkins/jenkins.log"
cat /var/lib/jenkins/secrets/initialAdminPassword
