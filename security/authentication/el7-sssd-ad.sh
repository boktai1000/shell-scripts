# https://access.redhat.com/articles/3023951

# You can run this script directly with the following command, append domain name followed by domain administrator password
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/authentication/el7-sssd-ad.sh | sudo bash -s 

# Install Required Packages for SSSD
yum install -y krb5-workstation samba-common-tools sssd-ad oddjob-mkhomedir

# Backup krb5.conf file before modifying
cp /etc/krb5.conf /etc/krb5.conf.bak

# Create custom krb5.conf file
echo "[logging]
 default = FILE:/var/log/krb5libs.log

[libdefaults]
 default_realm = $1
 dns_lookup_realm = true
 dns_lookup_kdc = true
 ticket_lifetime = 24h
 renew_lifetime = 7d
 rdns = false
 forwardable = yes" > /etc/krb5.conf

# Obtain Kerberos credentials for a Windows administrative user
echo $2 | kinit Administrator

# Add machine to domain
net ads join -k

# List the keys for the system and check that the host principal is there
klist -k

# Use authconfig to enable SSSD for system authentication. Use the --enablemkhomedir to enable SSSD to create home directories.
authconfig --update --enablesssd --enablesssdauth --enablemkhomedir

# Create SSSD configuration file
echo "[sssd]
config_file_version = 2
domains = $1
services = nss, pam, pac

[domain/$1]
id_provider = ad
auth_provider = ad
chpass_provider = ad
access_provider = ad

cache_credentials = true
override_homedir = /home/%u
default_shell = /bin/bash" > /etc/sssd/sssd.conf

# Set proper permissions on SSSD file
chmod 600 /etc/sssd/sssd.conf

# Restart SSSD service
systemctl restart sssd
