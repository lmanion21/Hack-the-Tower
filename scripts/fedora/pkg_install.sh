#!/bin/bash

# Setup script for Fedora 30 based system

# Update
sudo dnf update -y

# Standard Development Tools
METAPKGS="@c-development @development-tools @development-libs @web-server-environment "

# Additional PKGS
PKGS="vim tmux curl htop cmake libusb libusb-devel httpd p7zip wireshark "

sudo dnf install $METAPKGS $PKGS

