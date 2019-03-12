# WIP Code - Needs to be tested further against Greenbone and ssh-audit.py

cp /etc/issue /etc/issue.bak
cp /etc/issue.net /etc/issue.net.bak
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

echo "Unauthorised access prohibited. Logs are recorded and monitored." > /etc/issue
echo "Unauthorised access prohibited. Logs are recorded and monitored." > /etc/issue.net

echo "Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com
HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,ssh-rsa,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ssh-rsa-cert-v01@openssh.com,ssh-dss-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com
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
PubkeyAuthentication no
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

systemctl restart sshd
