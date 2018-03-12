#!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

# Debian/Ubuntu
if [ -f /etc/debian_version ]; then
  codename="$(facter lsbdistcodename)"
  sudo apt-get install -y virtualbox-guest-dkms
fi

# RHEL
if [ -f /etc/redhat-release ]; then
  if [ -f /etc/os-release ]; then
    codename="$(facter operatingsystem)"
    if [[ $codename != "Fedora" ]]; then
      sudo yum -y install gcc kernel-devel kernel-headers dkms make bzip2 perl && \
        sudo yum -y group install "Development Tools"
    fi
    if [[ $codename == "Fedora" ]]; then
      sudo dnf -y install gcc kernel-devel kernel-headers dkms make bzip2 perl && \
        sudo dnf -y group install "Development Tools"
    fi
    sudo mkdir -p /mnt/virtualbox
    sudo mount -o loop /home/packer/VBoxGuestAdditions.iso /mnt/virtualbox
    sudo sh /mnt/virtualbox/VBoxLinuxAdditions.run
    sudo umount /mnt/virtualbox
    sudo rm -rf /home/packer/VBoxGuestAdditions.iso
  fi
fi
