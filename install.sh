#!/bin/bash

${WORKDIR?"Need to set WORKDIR env"} 2>/dev/null
type AN >/dev/null 2>&1 || { echo >&2 "Require AN script to be in path. Aborting."; exit 1; }

if [ -d $WORKDIR/perftools-setup ]l then
	echo "make sure to clone the github repo `perftools-setup` and proceed further."
	exit 255
fi

# Add scripts to the PATH
grep "perftools-setup\/nmon" ~/.bashrc
if [ $? -ne 0 ]; then
	echo "export PATH=\$PATH:${WORKDIR}/perftools-setup/nmon" >> ~/.bashrc
fi

grep "perftools-setup\/oprofile" ~/.bashrc
if [ $? -ne 0 ]; then
	echo "export PATH=\$PATH:${WORKDIR}/perftools-setup/oprofile" >> ~/.bashrc
fi

# Copy the required script to all slave nodes.
DN "mkdir -p $WORKDIR/perftools-setup/oprofile/"
CP $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh
CP $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh
AN "chmod +x $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh"
AN "chmod +x $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh"

if [ -f /usr/bin/apt-get ]; then
	# ubuntu

	# install `nmon` in all nodes
	AN "sudo apt-get -y install nmon >/dev/null 2>&1"

	# Create user for oprofile.
	AN "sudo adduser --disabled-password --gecos '' oprofile"
	AN "echo "oprofile:passw0rd" | sudo chpasswd"

	# install `oprofile` in all nodes
	AN "$WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh $WORKDIR"

else
	# RHEL

	# install `nmon` in all nodes
	AN "sudo yum -y install epel-release  >/dev/null 2>&1"
	AN "sudo yum -y install nmon  >/dev/null 2>&1"

	# Create user for oprofile.
	sudo useradd oprofile
	echo "passw0rd" | sudo passwd  --stdin oprofile

	# install `oprofile` in all nodes


	
fi

echo "Installation Completed !!"


