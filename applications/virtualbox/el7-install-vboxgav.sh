# You can run this script directly with the following command:

# Append your version number after "| sudo bash -s" ; Example- "| sudo bash -s 6.0.4"
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/virtualbox/el7-install-vboxgav.sh | sudo bash -s 

# Set VirtualBox Variable so argument from command line gets passed through
VBOX_VERSION=$1

sudo yum install -y bzip2

cd /tmp
curl -O http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso

mount -o loop,ro VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run

umount /mnt
rm /tmp/VBoxGuestAdditions_$VBOX_VERSION.iso
