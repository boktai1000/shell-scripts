#!/bin/bash

# https://gist.githubusercontent.com/sukharevd/6087988/raw/3a27fa74df2102057e157136b2be55761092bdc4/wildfly-install.sh

# You can run this script directly with either of the following commands
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/wildfly/nix-install-wildfly.sh | sudo bash
# curl -s https://bitbucket.org/boktai1000/shell-scripts/raw/master/applications/wildfly/nix-install-wildfly.sh | sudo bash

WILDFLY_VERSION=${1:-16.0.0.Final}
WILDFLY_FILENAME=wildfly-$WILDFLY_VERSION
WILDFLY_ARCHIVE_NAME=$WILDFLY_FILENAME.tar.gz
WILDFLY_DOWNLOAD_ADDRESS=http://download.jboss.org/wildfly/$WILDFLY_VERSION/$WILDFLY_ARCHIVE_NAME

INSTALL_DIR=/opt
WILDFLY_FULL_DIR=$INSTALL_DIR/$WILDFLY_FILENAME
WILDFLY_DIR=$INSTALL_DIR/wildfly

WILDFLY_USER="wildfly"
WILDFLY_SERVICE="wildfly"
WILDFLY_MODE="standalone"

WILDFLY_STARTUP_TIMEOUT=240
WILDFLY_SHUTDOWN_TIMEOUT=30

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Downloading: $WILDFLY_DOWNLOAD_ADDRESS..."
[ -e "$WILDFLY_ARCHIVE_NAME" ] && echo 'Wildfly archive already exists.'
if [ ! -e "$WILDFLY_ARCHIVE_NAME" ]; then
    curl -O "$WILDFLY_DOWNLOAD_ADDRESS"
    if [ $? -ne 0 ]; then
        echo "Not possible to download Wildfly."
        exit 1
    fi
fi

echo "Cleaning up..."
rm -f "$WILDFLY_DIR"
rm -rf "$WILDFLY_FULL_DIR"
rm -rf "/var/run/$WILDFLY_SERVICE/"
rm -f "/etc/init.d/$WILDFLY_SERVICE"

echo "Installation..."
mkdir "$WILDFLY_FULL_DIR"
tar -xzf "$WILDFLY_ARCHIVE_NAME" -C $INSTALL_DIR
ln -s "$WILDFLY_FULL_DIR"/ $WILDFLY_DIR
useradd -s /sbin/nologin $WILDFLY_USER
chown -R $WILDFLY_USER:$WILDFLY_USER $WILDFLY_DIR
chown -R $WILDFLY_USER:$WILDFLY_USER $WILDFLY_DIR/

#mkdir -p /var/log/$WILDFLY_SERVICE

echo "Registrating Wildfly as service..."
# if should use systemd
if [ -x /bin/systemctl ]; then
    # Script from $WILDFLY_DIR/docs/contrib/scripts/systemd/launch.sh didn't work for me
    cat > $WILDFLY_DIR/bin/launch.sh << "EOF"
#!/bin/sh

if [ "x$WILDFLY_HOME" = "x" ]; then
    WILDFLY_HOME="/opt/wildfly"
fi

if [ "x$1" = "xdomain" ]; then
    echo 'Starting Wildfly in domain mode.'
    $WILDFLY_HOME/bin/domain.sh -c $2 -b $3
    #>> /var/log/$WILDFLY_SERVICE/server-`date +%Y-%m-%d`.log
else
    echo 'Starting Wildfly in standalone mode.'
    $WILDFLY_HOME/bin/standalone.sh -c $2 -b $3
    #>> /var/log/$WILDFLY_SERVICE/server-`date +%Y-%m-%d`.log
fi
EOF
    # $WILDFLY_HOME is not visible here
    sed -i -e 's,WILDFLY_HOME=.*,WILDFLY_HOME='$WILDFLY_DIR',g' $WILDFLY_DIR/bin/launch.sh
    #sed -i -e 's,$WILDFLY_SERVICE,'$WILDFLY_SERVICE',g' $WILDFLY_DIR/bin/launch.sh
    chmod +x $WILDFLY_DIR/bin/launch.sh
    
    cp $WILDFLY_DIR/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/$WILDFLY_SERVICE.service
    WILDFLY_SERVICE_CONF=/etc/default/$WILDFLY_SERVICE
    # To install multiple instances of Wildfly replace all hardcoding in systemd file
    sed -i -e 's,EnvironmentFile=.*,EnvironmentFile='$WILDFLY_SERVICE_CONF',g' /etc/systemd/system/$WILDFLY_SERVICE.service
    sed -i -e 's,User=.*,User='$WILDFLY_USER',g' /etc/systemd/system/$WILDFLY_SERVICE.service
    sed -i -e 's,PIDFile=.*,PIDFile=/var/run/wildfly/'$WILDFLY_SERVICE'.pid,g' /etc/systemd/system/$WILDFLY_SERVICE.service
    sed -i -e 's,ExecStart=.*,ExecStart='$WILDFLY_DIR'/bin/launch.sh $WILDFLY_MODE $WILDFLY_CONFIG $WILDFLY_BIND,g' /etc/systemd/system/$WILDFLY_SERVICE.service
    systemctl daemon-reload
    #systemctl enable $WILDFLY_SERVICE.service
fi

# if non-systemd Debian-like distribution
if [ ! -x /bin/systemctl -a -r /lib/lsb/init-functions ]; then
    cp $WILDFLY_DIR/docs/contrib/scripts/init.d/wildfly-init-debian.sh /etc/init.d/$WILDFLY_SERVICE
    sed -i -e 's,NAME=wildfly,NAME='$WILDFLY_SERVICE',g' /etc/init.d/$WILDFLY_SERVICE
    WILDFLY_SERVICE_CONF=/etc/default/$WILDFLY_SERVICE
fi

# if non-systemd RHEL-like distribution
if [ ! -x /bin/systemctl -a -r /etc/init.d/functions ]; then
    cp $WILDFLY_DIR/docs/contrib/scripts/init.d/wildfly-init-redhat.sh /etc/init.d/$WILDFLY_SERVICE
    WILDFLY_SERVICE_CONF=/etc/default/wildfly.conf
    chmod 755 /etc/init.d/$WILDFLY_SERVICE
fi

# if neither Debian nor RHEL like distribution
if [ ! -x /bin/systemctl -a ! -r /lib/lsb/init-functions -a ! -r /etc/init.d/functions ]; then
cat > /etc/init.d/$WILDFLY_SERVICE << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides:          ${WILDFLY_SERVICE}
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/Stop ${WILDFLY_FILENAME}
### END INIT INFO

WILDFLY_USER=${WILDFLY_USER}
WILDFLY_DIR=${WILDFLY_DIR}

case "$1" in
start)
echo "Starting ${WILDFLY_FILENAME}..."
start-stop-daemon --start --background --chuid $WILDFLY_USER --exec $WILDFLY_DIR/bin/standalone.sh
exit $?
;;
stop)
echo "Stopping ${WILDFLY_FILENAME}..."

start-stop-daemon --start --quiet --background --chuid $WILDFLY_USER --exec $WILDFLY_DIR/bin/jboss-cli.sh -- --connect command=:shutdown
exit $?
;;
log)
echo "Showing server.log..."
tail -500f $WILDFLY_DIR/standalone/log/server.log
;;
*)
echo "Usage: /etc/init.d/wildfly {start|stop}"
exit 1
;;
esac
exit 0
EOF
    sed -i -e 's,${WILDFLY_USER},'$WILDFLY_USER',g; s,${WILDFLY_FILENAME},'"$WILDFLY_FILENAME"',g; s,${WILDFLY_SERVICE},'$WILDFLY_SERVICE',g; s,${WILDFLY_DIR},'$WILDFLY_DIR',g' /etc/init.d/$WILDFLY_SERVICE
    chmod 755 /etc/init.d/$WILDFLY_SERVICE
fi

if [ ! -z "$WILDFLY_SERVICE_CONF" ]; then
    echo "Configuring service..."
    echo JBOSS_HOME=\"$WILDFLY_DIR\" > $WILDFLY_SERVICE_CONF
    echo JBOSS_USER=$WILDFLY_USER >> $WILDFLY_SERVICE_CONF
    echo WILDFLY_HOME=\"$WILDFLY_DIR\" > $WILDFLY_SERVICE_CONF
    echo WILDFLY_USER=\"$WILDFLY_USER\" > $WILDFLY_SERVICE_CONF
    echo STARTUP_WAIT=$WILDFLY_STARTUP_TIMEOUT >> $WILDFLY_SERVICE_CONF
    echo SHUTDOWN_WAIT=$WILDFLY_SHUTDOWN_TIMEOUT >> $WILDFLY_SERVICE_CONF
    echo WILDFLY_CONFIG=$WILDFLY_MODE.xml >> $WILDFLY_SERVICE_CONF
    echo WILDFLY_MODE=$WILDFLY_MODE >> $WILDFLY_SERVICE_CONF
    echo WILDFLY_BIND=0.0.0.0 >> $WILDFLY_SERVICE_CONF
fi

echo "Configuring application server..."
sed -i -e 's,<deployment-scanner path="deployments" relative-to="jboss.server.base.dir" scan-interval="5000",<deployment-scanner path="deployments" relative-to="jboss.server.base.dir" scan-interval="5000" deployment-timeout="'$WILDFLY_STARTUP_TIMEOUT'",g' $WILDFLY_DIR/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml
sed -i -e 's,<inet-address value="${jboss.bind.address:127.0.0.1}"/>,<any-address/>,g' $WILDFLY_DIR/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml
sed -i -e 's,<socket-binding name="ajp" port="${jboss.ajp.port:8009}"/>,<socket-binding name="ajp" port="${jboss.ajp.port:28009}"/>,g' $WILDFLY_DIR/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml
sed -i -e 's,<socket-binding name="http" port="${jboss.http.port:8080}"/>,<socket-binding name="http" port="${jboss.http.port:28080}"/>,g' $WILDFLY_DIR/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml
sed -i -e 's,<socket-binding name="https" port="${jboss.https.port:8443}"/>,<socket-binding name="https" port="${jboss.https.port:28443}"/>,g' $WILDFLY_DIR/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml
sed -i -e 's,<socket-binding name="osgi-http" interface="management" port="8090"/>,<socket-binding name="osgi-http" interface="management" port="28090"/>,g' $WILDFLY_DIR/$WILDFLY_MODE/configuration/$WILDFLY_MODE.xml

[ -x /bin/systemctl ] && systemctl start $WILDFLY_SERVICE || service $WILDFLY_SERVICE start

echo "Done."