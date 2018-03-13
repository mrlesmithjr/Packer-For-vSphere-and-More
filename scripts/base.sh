#!/bin/bash

set -e
set -x

# Debian/Ubuntu
if [ -f /etc/debian_version ]; then
  codename="$(facter lsbdistcodename)"

  # We need to cleanup for old repo update issues for hash mismatch
  if [[ $codename == "precise" ]]; then
    sudo apt-get clean
    sudo rm -r /var/lib/apt/lists/*
  fi

  #update apt-cache
  sudo apt-get update

  #install packages
  sudo apt-get install -y python-minimal

  #add check for ssh keys on reboot...regenerate if neccessary
  sudo bash -c "sed -i -e 's|exit 0||' /etc/rc.local"
  sudo bash -c "sed -i -e 's|.*test -f /etc/ssh/ssh_host_dsa_key.*||' /etc/rc.local"
  sudo bash -c "echo 'test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server' >> /etc/rc.local"
  sudo bash -c "echo 'exit 0' >> /etc/rc.local"
fi

# RHEL
if [ -f /etc/redhat-release ]; then
  codename="$(facter operatingsystem)"
  if [[ $codename != "Fedora" ]]; then
    sudo yum -y install python-devel
  fi
  if [[ $codename == "Fedora" ]]; then
    sudo dnf -y install python-devel python-dnf
  fi
fi
