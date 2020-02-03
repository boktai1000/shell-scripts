# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/windows_integration_guide/index#sssd-ad-proc
# Note to authenticate you need to do "su - user@DOMAIN.TLD" or ssh using "user@DOMAIN.TLD"

# https://help.ubuntu.com/lts/serverguide/sssd-ad.html
# https://help.ubuntu.com/lts/serverguide/samba-ad-integration.html
# https://answers.launchpad.net/ubuntu/+question/293540
# https://lists.fedorahosted.org/archives/list/sssd-users@lists.fedorahosted.org/thread/Y62YBXJQ2PCWFTMDLBVYUPQ63CNTJMHI/
# https://community.spiceworks.com/topic/2018717-joining-debian-machine-to-ad-domain-packages-not-found
# https://serverfault.com/questions/598476/how-to-use-realmd-in-ubuntu-14-04-lts-to-join-an-active-directory-domain
# http://blog.admindiary.com/integrate-ubuntu-active-directory-using-kerberos-realmd-sssd/
# https://rohanc.me/sssd-active-directory-ubuntu/
# https://www.server-world.info/en/note?os=Ubuntu_18.04&p=realmd

# Note: Hostname must be 15 characters or less

# You can run this script directly with the following command, $1 is your domain and $2 is your Administrator@ad.example.com password
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/auth/nix-realm.sh | sudo bash

# Install required packages for AD integration / join via realm
apt-get install realmd packagekit

# ex: "realm join ad.example.com" - $1 is your domain and $2 is your Administrator@ad.example.com password
# Note: This is not working currently in the script - commenting out
# echo $2 | realm join $1
echo "Be sure to join domain with command realm join - currently not scripted"

# Fix Home Directories
# https://help.ubuntu.com/lts/serverguide/sssd-ad.html
echo "Be sure to fix Home Directories manually at https://help.ubuntu.com/lts/serverguide/sssd-ad.html - currently not scripted"

# Fix FQDN Requirement
# Comment out requirement to use fully qualified names, effectively disabling
# sudo sed -i -e 's|use_fully_qualified_names = True|#use_fully_qualified_names = True|' /etc/sssd/sssd.conf
