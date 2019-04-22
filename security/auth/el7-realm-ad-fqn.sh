# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/windows_integration_guide/index#sssd-ad-proc
# Note to authenticate you need to do "su - user@DOMAIN.TLD" or ssh using "user@DOMAIN.TLD"

# Note: Hostname must be 15 characters or less

# You can run this script directly with the following command, append domain name, workgroup, and then Admin password in that order
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/auth/el7-realm-ad-fqn.sh | sudo bash -s 

# Install required packages for AD integration / join via realm
yum install -y realmd oddjob oddjob-mkhomedir sssd samba-common-tools

# ex: "realm join ad.example.com" - $1 is your domain and $2 is your Administrator@ad.example.com password
echo $2 | realm join $1
