# You can run this script directly with the following command
# curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/security/openssh/openssh-harden-pubkey.sh | sudo bash

# Backup files before continuing
cp /etc/issue /etc/issue.bak-"$(date --utc +%FT%T.%3NZ)"
cp /etc/issue.net /etc/issue.net.bak-"$(date --utc +%FT%T.%3NZ)"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak-"$(date --utc +%FT%T.%3NZ)"

# Create Warning Banners for System Access
echo "Unauthorised access prohibited. Logs are recorded and monitored." | sudo tee /etc/issue
echo "Unauthorised access prohibited. Logs are recorded and monitored." | sudo tee /etc/issue.net

# Create new hardened sshd_config file
echo "# SSH port.
Port 22

# Listen on IPv4 only.
ListenAddress 0.0.0.0

# Protocol version 1 has been exposed.
Protocol 2

#
# OpenSSH cipher-related release notes.
# OpenSSH 6.2: added support for AES-GCM authenticated encryption. 
# The cipher is available as aes128-gcm@openssh.com and aes256-gcm@openssh.com.
# OpenSSH 6.5: added new cipher chacha20-poly1305@openssh.com.
# OpenSSH 6.7: removed unsafe algorithms. CBC ciphers are disabled by default:
# aes128-cbc, aes192-cbc, aes256-cbc, 3des-cbc, blowfish-cbc, cast128-cbc.
# OpenSSH 6.9: promoted chacha20-poly1305@openssh.com to be the default cipher.
#
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

#
# OpenSSH 6.2: added support for the UMAC-128 MAC as umac-128@openssh.com 
# and umac-128-etm@openssh.com. The latter being an encrypt-then-mac mode.
# Do not use umac-64 or umac-64-etm because of a small 64 bit tag size.
# Do not use any SHA1 (e.g. hmac-sha1, hmac-sha1-etm@openssh.com) MACs 
# because of a weak hashing algorithm. 
# Do not use hmac-sha2-256, hmac-sha2-512 or umac-128@openssh.com 
# because of an encrypt-and-MAC mode. See the link below:
# https://crypto.stackexchange.com/questions/202/should-we-mac-then-encrypt-or-encrypt-then-mac
#
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com

#
# OpenSSH 6.5: added support for ssh-ed25519. It offers better security 
# than ECDSA and DSA.
# OpenSSH 7.0: disabled support for ssh-dss. 
# OpenSSH 7.2: added support for rsa-sha2-512 and rsa-sha2-256.
#
HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,ssh-rsa,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ssh-rsa-cert-v01@openssh.com,ssh-dss-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com

#
# OpenSSH 6.5: added support for key exchange using elliptic-curve
# Diffie Hellman in Daniel Bernstein's Curve25519.
# OpenSSH 7.3: added support for diffie-hellman-group14-sha256,
# diffie-hellman-group16-sha512 and diffie-hellman-group18-sha512.
#
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group18-sha512,diffie-hellman-group16-sha512,diffie-hellman-group14-sha256

# HostKeys for protocol version 2.
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Disabled because uses a small 1024 bit key.
#HostKey /etc/ssh/ssh_host_dsa_key

# Disabled because uses weak elliptic curves.
# See: https://safecurves.cr.yp.to/
#HostKey /etc/ssh/ssh_host_ecdsa_key


# INFO is a basic logging level that will capture user login/logout activity.
# DEBUG logging level is not recommended for production servers.
LogLevel INFO

# Disconnect if no successful login is made in 60 seconds.
LoginGraceTime 60

# Do not permit root logins via SSH.
PermitRootLogin no

# Check file modes and ownership of the user's files before login.
StrictModes yes

# Close TCP socket after 2 invalid login attempts.
MaxAuthTries 2

# The maximum number of sessions per network connection.
MaxSessions 3

# User/group permissions.
DenyUsers root
DenyGroups root

# Password and public key authentications.
PasswordAuthentication yes
PermitEmptyPasswords no
PubkeyAuthentication yes
AuthorizedKeysFile  .ssh/authorized_keys

# Disable unused authentications mechanisms.
ChallengeResponseAuthentication no
KerberosAuthentication no
GSSAPIAuthentication no
HostbasedAuthentication no
IgnoreUserKnownHosts yes

# Disable insecure access via rhosts files.
IgnoreRhosts yes

AllowAgentForwarding no
AllowTcpForwarding no

# Disable X Forwarding.
X11Forwarding no

# Disable message of the day but print last log.
PrintMotd no
PrintLastLog yes

# Show banner.
Banner /etc/issue

# Do not send TCP keepalive messages.
TCPKeepAlive no

# Default for new installations.
UsePrivilegeSeparation sandbox

# Prevent users from potentially bypassing some access restrictions.
PermitUserEnvironment no

# Disable compression.
Compression no

# Disconnect the client if no activity has been detected for 900 seconds.
ClientAliveInterval 900
ClientAliveCountMax 0

# Do not look up the remote hostname.
UseDNS no

UsePAM yes" > /etc/ssh/sshd_config

# Restart SSH Daemon
systemctl restart sshd
