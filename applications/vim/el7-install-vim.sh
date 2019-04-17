# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/vim/el7-install-vim.sh)

# Install VIM - supersedes VI
sudo yum install -y vim

# Backup vim.sh file
cp /etc/profile.d/vim.sh /etc/profile.d/vim.sh.bak

# Create new vim.sh that applies alias to all users instead of exclusing root and just checks for vim binary
echo "if [ -n "$BASH_VERSION" -o -n "$KSH_VERSION" -o -n "$ZSH_VERSION" ];then
  if [ -f /usr/bin/vim ]; then
         alias vi='vim'
  fi
fi" > /etc/profile.d/vim.sh

# Reload profile without loading a new shell - so Alias updates properly/etc.
source /etc/profile
