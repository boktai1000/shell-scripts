# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/vim/el7-install-vim.sh)

# Install VIM - supersedes VI
sudo yum install -y vim

# Reload profile without loading a new shell - so Alias updates properly/etc.
source /etc/profile
