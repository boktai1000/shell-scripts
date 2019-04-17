# You can run this script directly with the following command
# source <(curl -s https://raw.githubusercontent.com/boktai1000/shell-scripts/master/applications/vim/el7-install-vim.sh)

# Install VIM - supersedes VI and includes syntax highlighting
sudo yum install -y vim

# Backup /etc/profile.d/vim.sh
cp /etc/profile.d/vim.sh /etc/profile.d/vim.sh.orig

# Create new vim.sh that applies alias to all users if vim binary is present
echo "if [ -n "$BASH_VERSION" -o -n "$KSH_VERSION" -o -n "$ZSH_VERSION" ];then
  if [ -f /usr/bin/vim ]; then
         alias vi='vim'
  fi
fi" > /etc/profile.d/vim.sh

# Source vim.sh to load it
. /etc/profile.d/vim.sh
