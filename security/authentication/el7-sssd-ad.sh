# https://access.redhat.com/articles/3023951
# Note: Hostname must be 15 characters or less

# You can run this script directly with the following command, append domain name, workgroup, and then Admin password in that order
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

# Backup Samba configuration file
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Configure the Samba server to connect to the AD server.
echo "# See smb.conf.example for a more detailed config file or
# read the smb.conf manpage.
# Run 'testparm' to verify the config is correct after
# you modified it.

[global]
        workgroup = $2
        client signing = yes
        client use spnego = yes
        kerberos method = secrets and keytab
        log file = /var/log/samba/%m.log
        password server = $1
        realm = $1
        security = ads

[homes]
        comment = Home Directories
        valid users = %S, %D%w%S
        browseable = No
        read only = No
        inherit acls = Yes

[printers]
        comment = All Printers
        path = /var/tmp
        printable = Yes
        create mask = 0600
        browseable = No

[print$]
        comment = Printer Drivers
        path = /var/lib/samba/drivers
        write list = @printadmin root
        force group = @printadmin
        create mask = 0664
        directory mask = 0775" > /etc/samba/smb.conf

# Obtain Kerberos credentials for a Windows administrative user
echo $3 | kinit Administrator

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
