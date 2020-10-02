# https://askubuntu.com/questions/1036676/how-to-set-static-ip-via-script-on-ubuntu-18-04
# https://www.howtoforge.com/linux-basics-set-a-static-ip-on-ubuntu
# vi /etc/netplan/50-cloud-init.yaml
# vi /etc/netplan/*.yaml

# Script running order: ./nix-new-ip.sh -s yourip yourgateway yourdns1 yourdns2 yourdomain

yourip=${1:-192.168.1.117/24}
yourgateway=${2:-192.168.1.1}
yourdns1=${3:-192.168.1.1}
yourdns2=${4:-192.168.1.1}
yourdomain=${5:-WORKGROUP}

# Backup original file
cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak-"$(date --utc +%FT%T.%3NZ)"

echo "# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        ens160:
            addresses:
            - $yourip
            gateway4: $yourgateway
            nameservers:
                addresses:
                - $yourdns1
                - $yourdns2
                search:
                - $yourdomain
    version: 2" > /etc/netplan/50-cloud-init.yaml
