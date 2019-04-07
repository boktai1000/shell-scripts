tomcatmajorversion="`echo $1 | cut -c1-1`"
tomcatminorversion="$1"
yourip=$(hostname -I | awk '{print $1}')
tomcatport="${2:-8080}"

echo "Validate your configuration file port: 8080" > 8080testfile

sed -i "s/8080/$tomcatport/g" 8080testfile

echo "Your Major Version $tomcatmajorversion"
echo "Your Minor Version $tomcatminorversion"
echo "Your IP address $yourip"
echo "Your Tomcat Port $tomcatport"
cat 8080testfile
