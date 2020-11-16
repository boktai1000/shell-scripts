# Update to Central US - Chicago
sudo ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

# Undo to UTC - Verified on Ubuntu 18.04 Server
# sudo unlink /etc/localtime
# sudo ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Additional References
# https://unix.stackexchange.com/questions/297147/why-is-etc-localtime-a-symbolic-link
# https://linuxize.com/post/how-to-remove-symbolic-links-in-linux/
