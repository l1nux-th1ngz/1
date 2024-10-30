#!/bin/bash

echo "This must be run as root or a user with sudo privileges"

# Create and edit the backports.list file
sudo bash -c 'echo "deb https://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware" > /etc/apt/sources.list.d/backports.list'

# Update package lists
sudo apt-get update

echo "Backports list added and package lists updated."
