# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/windows_integration_guide/index#sssd-ad-proc
# Note to authenticate you need to do "su - user@DOMAIN.TLD" or ssh using "user@DOMAIN.TLD"

yum install -y realmd oddjob oddjob-mkhomedir sssd samba-common-tools

# ex: "realm join ad.example.com" - $1 is your domain and $2 is your Administrator@ad.example.com password
echo $2 | realm join $1
