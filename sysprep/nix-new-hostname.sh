# https://linuxize.com/post/how-to-change-hostname-on-ubuntu-18-04/
# https://www.cyberciti.biz/faq/ubuntu-18-04-lts-change-hostname-permanently/

yourhostname=$1

# Update Hostname
hostnamectl set-hostname $yourhostname

# Update /etc/hosts file
# Remove old 127.0.0.1 entry and replace with new hostname
# vi /etc/hosts

echo 'update your /etc/hosts'
