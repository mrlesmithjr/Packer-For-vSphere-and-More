#!/bin/bash

# # Add usernames to add to /etc/sudoers for passwordless sudo
# users=("ubuntu" "admin")
#
# for user in "${users[@]}"
# do
#   cat /etc/sudoers | grep ^$user
#   RC=$?
#   if [ $RC != 0 ]; then
#     bash -c "echo \"$user ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers"
#   fi
# done


#grab Ubuntu Codename
codename="$(lsb_release -c | awk {'print $2}')"

#update apt-cache
sudo apt-get update

#install packages
sudo apt-get install -y python-minimal open-vm-tools

#Stop services for cleanup
sudo service rsyslog stop

#clear audit logs
if [ -f /var/log/audit/audit.log ]; then
  sudo bash -c "cat /dev/null > /var/log/audit/audit.log"
fi
if [ -f /var/log/wtmp ]; then
  sudo bash -c "cat /dev/null > /var/log/wtmp"
fi
if [ -f /var/log/lastlog ]; then
  sudo bash -c "cat /dev/null > /var/log/lastlog"
fi

#cleanup persistent udev rules
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
  sudo rm /etc/udev/rules.d/70-persistent-net.rules
fi

#cleanup /tmp directories
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

#cleanup current ssh keys
sudo rm -f /etc/ssh/ssh_host_*

#add check for ssh keys on reboot...regenerate if neccessary
sudo bash -c "sed -i -e 's|exit 0||' /etc/rc.local"
sudo bash -c "sed -i -e 's|.*test -f /etc/ssh/ssh_host_dsa_key.*||' /etc/rc.local"
sudo bash -c "echo 'test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server' >> /etc/rc.local"
sudo bash -c "echo 'exit 0' >> /etc/rc.local"

#reset hostname
sudo bash -c "cat /dev/null > /etc/hostname"

#cleanup apt
sudo apt-get clean

#cleanup shell history
history -w
history -c
