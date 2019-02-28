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
# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/scripts/el7-initial-prep.sh | sudo bash

# Update packages
/usr/bin/yum update -y

# Install packages required or recommended for sysprep
/usr/bin/yum install -y bc bzip2 perl mlocate open-vm-tools wget yum-utils

# Clean yum
/usr/bin/yum clean all
/bin/rm -rf /var/cache/yum
