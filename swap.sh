#!/bin/bash

set -e

# Remove swap
sudo swapoff -a
sudo rm -f /swapfile
if [ -f /etc/fstab.orig ]; then
    sudo cp /etc/fstab /etc/fstab.changed
    sudo cp /etc/fstab.orig /etc/fstab
fi
sudo swapon -a
#swapon -s

dd if=/dev/zero of=/swapfile bs=1024 count=2097152 > /dev/null
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.orig
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
swapon -a
#swapon -s

