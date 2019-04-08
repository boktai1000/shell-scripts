# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/windows_integration_guide/index#sssd-ad-proc

yum install -y realmd oddjob oddjob-mkhomedir sssd samba-common-tools

echo $2 | realm join $1
