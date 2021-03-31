#!/bin/bash

# HackTheTower startup script #
# 1.) Ensure that the bladeRF is plugged with lights on...
# 2.) This script works with x115 model of bladeRF (Check the box to ensure you have this model)
# 3.) If you have a different radio model, just change the path for the FPGA image, you shouldn't have to worry about the firmware image

# Loading Radio FPGA and Firmware #
bladeRF-cli -f /usr/share/Nuand/bladeRF/bladeRF_fw.img
bladeRF-cli -l /usr/share/Nuand/bladeRF/hostedx115.rbf

# Starting NextEPC and webclient #

#start_EPC () {
#	./nextepc-epcd
#}

#start_WebGUI () {
#	iptables -t nat -A POSTROUTING -o wlps10 -j MASQUERADE
#	iptables -I INPUT -i pgwtun -j ACCEPT
#	cd webui
#	npm run dev
#	***Open Browser to localhost:3000***
#}

#start_ENB () {
#	srsenb
#}

#start_EPC
#start_WebGUI
#start_ENB

gnome-terminal --tab -t "NextEPC" -e "bash -c './nextepc-epcd'; read -n1" --tab -t "Web Interface" -e "bash -c 'iptables -t nat -A POSTROUTING -o wlps10 -j MASQUERADE; iptables -I INPUT -i pgwtun -j ACCEPT; cd webui; npm run dev'" --tab -t "srsENB" -e "bash -c 'srsenb'"
#	***Need the above three functions to be loaded on separate tabs***
