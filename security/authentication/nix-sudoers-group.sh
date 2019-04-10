
# https://www.reddit.com/r/sysadmin/comments/2dc7jf/best_way_to_automate_the_process_of_joining_linux/cjo65jf/
# Add your group to Sudoers file - Note for Groups with spaces type as follows: linux\ administrators
echo "%$1  ALL=(ALL) ALL" | sudo tee -a /etc/sudoers > /dev/null
