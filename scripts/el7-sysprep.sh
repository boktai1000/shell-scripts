#!/bin/bash

# Script to prepare Enterprise Linux 7 (CentOS/RHEL) base-image for deploying as a template
# Created by: Keegan Jacobson
# Based on: 
#   https://notesfrommwhite.net/2015/06/11/how-to-create-a-linux-vmware-template/
#   https://linuxacademy.com/community/posts/show/topic/5298-centos-71-vmware-template-script
#   https://gist.github.com/AfroThundr3007730/ff5229c5b1f9a018091b14ceac95aa55
#   https://github.com/frapposelli/packer-templates/blob/master/scripts/centos-vmware-vcloud_cleanup.sh
#   https://github.com/jonatasbaldin/shell-script/blob/master/centos-sysprep.sh
#   https://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/
#   http://libguestfs.org/virt-sysprep.1.html
# Tested on CentOS 7
# This script is intended to be run on a machine created to be a template, such as a VMware Template for example
# You can run it directly with curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/el7-sysprep.sh | sudo bash

# Stop logging servers
/sbin/service rsyslog stop > /dev/null
/sbin/service auditd stop > /dev/null

# Update packages
/usr/bin/yum update -y

# Install open-vm-tools and yum-utils
/usr/bin/yum install -y open-vm-tools yum-utils

# Remove old kernels
/bin/package-cleanup --oldkernels --count=1

# Clean yum
/usr/bin/yum clean all
/bin/rm -rf /var/cache/yum

# Force logs rotate and remove old logs
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda

# Truncate the audit logs
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby

# Remove udev persistent rules
/bin/rm -f /etc/udev/rules.d/70*

# Remove mac address and uuids from any interface
/bin/sed -i '/^(HWADDR|UUID)=/d' /etc/sysconfig/network-scripts/ifcfg-*

# Clean temp directories
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*

# Remove ssh keys
/bin/rm -f /etc/ssh/*key*

# Remove root's SSH history and other cruft
/bin/rm -rf ~root/.ssh/
/bin/rm -f ~root/anaconda-ks.cfg

# Remove root's and users history
/bin/rm -f ~root/.bash_history
/bin/rm -f /home/*/.bash_history
unset HISTFILE
