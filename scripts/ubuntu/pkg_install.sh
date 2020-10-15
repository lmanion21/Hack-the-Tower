#!/bin/bash

# Setup script for Fedora 30 based system

# Update
sudo apt update -y

# Standard Development Tools
METAPKGS="subversion zlib1g-dev build-essential git python python3 python3-distutils
        libncurses5-dev gawk gettext unzip file libssl-dev wget libelf-dev ecj fastjar
        java-propose-classpath"

# Additional PKGS
PKGS="vim tmux curl htop cmake apache2 libusb-1.0-0-dev libusb-dev bladerf libbladerf-dev automake p7zip wireshark php"

sudo apt-get install $METAPKGS $PKGS

