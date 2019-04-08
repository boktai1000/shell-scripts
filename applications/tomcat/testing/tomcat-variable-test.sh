# You can run this script directly with the following command
# Append your version number followed by desired port number after 'sudo bash -s' ex: 'sudo bash -s 9.0.17 9090'
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/tomcat/testing/tomcat-variable-test.sh | sudo bash -s 

tomcatlatest="$(curl -s https://api.github.com/repos/apache/tomcat/tags | grep '"name"' | head -1 | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")"
tomcatminorversion=${1:-$tomcatlatest}
tomcatmajorversion="`echo $tomcatminorversion | cut -c1-1`"
yourip=$(hostname -I | awk '{print $1}')
tomcatport="${2:-8080}"

echo "Validate your configuration file port: 8080" > /tmp/8080testfile

sed -i "s/8080/$tomcatport/g" /tmp/8080testfile

echo "Your Major Version $tomcatmajorversion"
echo "Your Minor Version $tomcatminorversion"
echo "Your IP address $yourip"
echo "Your Tomcat Port $tomcatport"
echo "Tomcat Latest $tomcatlatest"
cat /tmp/8080testfile

rm /tmp/8080testfile
