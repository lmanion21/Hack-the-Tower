#!/bin/sh

# Installation of yate and yatebts following the guide from Nuand
# ref: https://github.com/Nuand/bladeRF/wiki/Setting-up-Yate-and-YateBTS-with-the-bladeRF

# Config
REPOS=$HOME/devel/repos
NULLDIR=$REPOS/null
LOGDIR=$NULLDIR/log
YATEDIR=$NULLDIR/yate
YATEBTSDIR=$NULLDIR/yatebts
BLADERFDIR=$REPOS/bladeRF
BLADERFHOSTDIR=$BLADERFDIR/host
CORES=4

# Setting up the yate group
if [ ! $(grep -E "^yate:" /etc/group) ] ; then
	printf "Creating yate group...\n"
	sudo groupadd yate
	sudo usermod -a -G yate $USER
else
	printf "yate group already in place...\n"
fi

# Creating bladeRF udev rule
# check if rule already present, add if not
if [ ! -f /etc/udev/rules.d/88-nuand.rules ] \
	&& [ ! -f /etc/udev/rules.d/90-yate.rules ]  ; then
	printf "Adding udev rule...\n"
	sudo sh -c 'printf "# nuand blade RF\n" > /etc/udev/rules.d/90-yate.rules'
	sudo sh -c 'printf "ATTR{idVendor}==\"1d50\", ATTR{idProduct}==\"6066\", MODE=\"660\", GROUP=\"yate\"\n" >> /etc/udev/rules.d/90-yate.rules'
	sudo udevadm control --reload-rules
else
	printf "udev rule already in place...\n"
fi

# Collet Yate and YateBTS source via SVN
if [ ! -d "$NULLDIR" ] ; then
	printf "Creating null dir for yate repos...\n"
	mkdir -p "$NULLDIR"
fi

if [ ! -d "$YATEDIR" ] ; then
	printf "Checking out yate from svn...\n"
	pushd "$NULLDIR"
	svn checkout http://yate.null.ro/svn/yate/trunk yate
	popd
else
	printf "Updating yate...\n"
	pushd "$YATEDIR"
	svn update
	popd
fi

if [ ! -d "$YATEBTSDIR" ] ; then
	printf "Checking out yatebts from svn...\n"
	pushd "$NULLDIR"
	svn checkout http://voip.null.ro/svn/yatebts/trunk yatebts
	popd
else
	printf "Updating yatebts...\n"
	pushd "$YATEBTSDIR"
	svn update
	popd
fi

# Building yate
if [ ! $(command -v yate-config) ] ; then
	printf "Building yate...\n"
	if [ ! -d "$LOGDIR" ] ; then
		mkdir "$LOGDIR"
	fi
	pushd "$YATEDIR"
	./autogen.sh
	./configure --prefix=/usr/local | tee ../yate.configure.log
	make -j"$CORES" | tee ../yate.make.log
	sudo make install | tee "$LOGDIR"/yate.install.log
	sudo make install | tee -a "$LOGDIR"/yate.install.log
	sudo ldconfig
	popd
else
	printf "yate already installed...\n"
fi

# --- WARNING ---
# GCC versions > 6 require a patch to yatebts
# ref: https://gist.github.com/smarek/b538465a711edc7e6d7652c82e76d374
# ref: https://yate.null.ro/mantis/view.php?id=416
# use `patch -p1 < yatebts-5.0.0-gcc6.patch` from $YATEBTSDIR
# --- WARNING ---

# Building yatebts
# TODO: cleaner check for yatebts
if [ ! -f /usr/local/lib/yate/server/bts/mbts ] ; then
	printf "Building yatebts...\n"
	if [ ! -d "$LOGDIR" ] ; then
		mkdir "$LOGDIR"
	fi
	pushd "$YATEBTSDIR"
	./autogen.sh
	./configure --prefix=/usr/local | tee ../yatebts.configure.log
	make -j"$CORES" | tee ../yate.make.log
	sudo make install | tee "$LOGDIR"/yatebts.install.log
	sudo make install | tee -a "$LOGDIR"/yatebts.install.log
	sudo ldconfig
	popd
else
	printf "yatebts already installed...\n"
fi

# Yate and YateBTS Configuration
# Group Write Permissions
# ref: https://github.com/Nuand/bladeRF/wiki/Setting-up-Yate-and-YateBTS-with-the-bladeRF
if [ ! -f /usr/local/etc/yate/snmp_data.conf ] ; then
	printf "Creating /usr/local/etc/yate/snmp_data.conf\n"
	sudo touch /usr/local/etc/yate/snmp_data.conf
fi
if [ ! -f /usr/local/etc/yate/tmsidata.conf ] ; then
	printf "Creating /usr/local/etc/yate/tmsidata.conf\n"
	sudo touch /usr/local/etc/yate/tmsidata.conf
fi
sudo chown root:yate /usr/local/etc/yate/*.conf
sudo chmod g+w /usr/local/etc/yate/*.conf

# Configuration items
# Must set Radio.Band, Radio.C0, and Identity.MCC
sudo sed -i 's/^Radio.Band=$/Radio.Band=850/' /usr/local/etc/yate/ybts.conf
sudo sed -i 's/^Radio.C0=$/Radio.C0=200/' /usr/local/etc/yate/ybts.conf
#sed -i 's/^;Identity.MCC=001$/Identity.MCC=001/' /usr/local/etc/yate/ybts.conf

# Set Scheduling Priority
# HIGH PRIORITY – – – – – > – – – – – > – – – – – > – – – – – > – – – – LEAST PRIORITY
# | real time priority (static priority) |       nice value (dynamic priority)       |
# |   99 ............ 50 ............ 1  | -20 ..... -10 ..... 0 ...... 10 ...... 19 |
#
# set in [transceiver] section for /usr/local/etc/yate/ybts.conf
#sed -i 's/^;?radio_read_priority=highest$/radio_read_priority=low/' 
#sed -i 's/^;?radio_send_priority=high$/radio_send_priority=low/' 

# Set SNMP to higher port values (allow non root binding)
sudo sed -i 's/^;port=161/port=20161/' /usr/local/etc/yate/ysnmpagent.conf
sudo sed -i 's/^;remote_port=162/port=20162/' /usr/local/etc/yate/ysnmpagent.conf

# bladeRF Repo and Toolkit
if [ ! -d "$BLADERFDIR" ] ; then
	printf "Cloning bladeRF...\n"
	pushd "$REPOS"
	git clone --recursive https://github.com/Nuand/bladeRF
	popd
else
	printf "Pulling bladeRF...\n"
	pushd "$BLADERFDIR"
	git pull
	popd
fi

# Fedora does not include the bladeRF directores in the library path by default
# ref: https://github.com/Nuand/bladeRF/tree/master/host
sudo sh -c 'printf "/usr/local/lib\n/usr/local/lib64\n" > /etc/ld.so.conf.d/local.conf'

if [ ! -d "$BLADERFHOSTDIR"/build ] ; then
	printf "Building bladerf...\n"
	pushd "$BLADERFHOSTDIR"
	mkdir build
	pushd build
	cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr/local \
		-DINSTALL_UDEV_RULES=ON \
		-DENABLE_LIBBLADERF_SYSLOG=ON ../ \
		| tee bladerf.configure.log
	make -j"$CORES" | tee bladerf.make.log
	sudo make install | tee bladerf.install.log
	sudo make install | tee -a bladerf.install.log
	sudo ldconfig
	popd
	popd
else
	printf "bladerf/host/build exists, remove to rebuild bladerf\n"
fi

# --- WARNING ---
# These instructions are incomplete.  The following needs to be added:
# 	1. Need to make sure httpd is install to support YateBTS web interface
#	ref: https://wiki.yatebts.com/index.php/Network_in_a_PC
# 	2. Need to turn off SELinux (until policy is fixed) via # setenforce 0
#		This supports web interface access to yate information
# 	
# It is still unclear if the BladeRF is working correctly.  It can be connected to
# but a good set of unit tests needs to be identified/determined to make sure it
# is working outside of yate/yatebts.
# --- WARNING ---
