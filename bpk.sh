#!/bin/bash

echo "This must be run as root or a user with sudo privileges"

backport_kernel() {
    sudo apt-get -y install -t bookworm-backports linux-image-amd64 linux-headers-amd64
    sudo apt-get -y install -t bookworm-backports firmware-linux firmware-linux-nonfree firmware-misc-nonfree
    sudo apt-get -y install -t bookworm-backports firmware-realtek firmware-atheros firmware-bnx2 firmware-bnx2x
    sudo apt-get -y install -t bookworm-backports firmware-brcm80211 firmware-ipw2x00 firmware-intelwimax
    sudo apt-get -y install -t bookworm-backports firmware-iwlwifi firmware-libertas firmware-netxen firmware-zd1211
}

# Call the function
backport_kernel
