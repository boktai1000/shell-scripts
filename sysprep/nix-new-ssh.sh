# https://www.cyberciti.biz/faq/howto-regenerate-openssh-host-keys/
# https://serverfault.com/questions/471327/how-to-change-a-ssh-host-key

# Create new set of keys
dpkg-reconfigure openssh-server

# Restart SSH
sudo systemctl restart ssh
