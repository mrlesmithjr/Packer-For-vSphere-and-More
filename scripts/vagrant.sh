#!/bin/bash

set -e
set -x

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

# Debian/Ubuntu
if [ -f /etc/debian_version ]; then
  sudo /usr/sbin/groupadd vagrant
  sudo /usr/sbin/useradd vagrant -g vagrant -s /bin/bash
  echo -e "vagrant\nvagrant" | sudo passwd vagrant
  sudo bash -c "echo 'vagrant        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers"
fi

# RHEL
if [ -f /etc/redhat-release ]; then
  if [ -f /etc/os-release ]; then
    sudo /usr/sbin/groupadd vagrant
    sudo /usr/sbin/useradd vagrant -g vagrant -G wheel
    sudo echo 'vagrant'|passwd --stdin vagrant
    sudo bash -c "echo 'vagrant        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers"
  fi
fi

# Vagrant specific
sudo bash -c "date > /etc/vagrant_box_build_time"

# Installing vagrant keys
sudo mkdir -pm 700 /home/vagrant/.ssh
sudo bash -c "wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys"
sudo chmod 0600 /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant /home/vagrant/.ssh
