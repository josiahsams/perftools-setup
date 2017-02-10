#!/bin/bash

${WORKDIR?"Need to set WORKDIR env"} 2>/dev/null
type AN >/dev/null 2>&1 || { echo >&2 "Require AN script to be in path. Aborting."; exit 1; }

if [ ! -d $WORKDIR/perftools-setup ]; then
	echo "make sure to clone the github repo `perftools-setup` and proceed further."
	exit 255
fi

# Copy the required script to all slave nodes.
DN "mkdir -p $WORKDIR/perftools-setup/oprofile/"

CP $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh

AN "chmod +x $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh"

CP $WORKDIR/perftools-setup/oprofile/oprofile_uninstall.sh $WORKDIR/perftools-setup/oprofile/oprofile_uninstall.sh
AN "chmod +x $WORKDIR/perftools-setup/oprofile/oprofile_uninstall.sh"

if [ -f /usr/bin/apt-get ]; then
	# ubuntu

	# install `nmon` in all nodes
	AN "sudo apt-get -y install nmon >/dev/null 2>&1"

	# Create user for oprofile.
	AN "sudo adduser --disabled-password --gecos '' oprofile"
	AN "echo "oprofile:passw0rd" | sudo chpasswd"

	# install `oprofile` in all nodes
	CP $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh
	AN "chmod +x $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh"
	AN "$WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh $WORKDIR/perftools-setup/oprofile"

	# required for pid_monitor.
	AN "sudo apt-get -y install dstat time  >/dev/null 2>&1"
	sudo apt-get -y install apache2
else
	# RHEL

	# install `nmon` in all nodes
	AN "sudo yum -y install epel-release  >/dev/null 2>&1"
	AN "sudo yum -y install nmon  >/dev/null 2>&1"

	# Create user for oprofile.
	sudo useradd oprofile
	echo "passw0rd" | sudo passwd  --stdin oprofile

	# install `oprofile` in all nodes
	CP $WORKDIR/perftools-setup/oprofile/oprofile_redhat_installer.sh $WORKDIR/perftools-setup/oprofile/oprofile_redhat_installer.sh
	AN "chmod +x $WORKDIR/perftools-setup/oprofile/oprofile_redhat_installer.sh"
	AN "$WORKDIR/perftools-setup/oprofile/oprofile_redhat_installer.sh $WORKDIR/perftools-setup/oprofile"

	# required for pid_monitor.
	AN "sudo yum -y install dstat time  >/dev/null 2>&1"
	sudo yum -y install httpd
fi

# Steps to install pid_monitor.
if [ ! -d ${WORKDIR}/pid_monitor ]; then
	git clone https://github.com/jschaub30/pid_monitor

	mkdir -p ${WORKDIR}/pid_monitor/rundir

	#Set execute permission for others so that apache can read files from this directory.
	sudo chmod o+x ${WORKDIR} ${WORKDIR}/pid_monitor ${WORKDIR}/pid_monitor/rundir
fi

if [ ! -L /var/www/html/rundir ]; then
	cd /var/www/html

	sudo ln -sf ${WORKDIR}/pid_monitor/rundir
fi

echo "pid_monitor is successfully configured. "
echo "Installation Completed !!"

tmpfile="${WORKDIR}/perftools-setup/tmp_b"
# Add scripts to the PATH
echo "#StartPerftoolsEnv" > $tmpfile
echo "export PATH=\$PATH:${WORKDIR}/perftools-setup/nmon" >> $tmpfile
echo "export PATH=\$PATH:${WORKDIR}/perftools-setup/oprofile" >> $tmpfile
echo "export PATH=\$PATH:${WORKDIR}/perftools-setup/pmonitor" >> $tmpfile
echo "export PATH=\$PATH:${WORKDIR}/perftools-setup/oprofile/wdir/oprofile_install/bin" >> $tmpfile
echo "#StopPerftoolsEnv" >> $tmpfile

grep -q '#StartPerftoolsEnv' $HOME/.bashrc
if [ $? -eq 0 ];
then
	sed -i '/#StartPerftoolsEnv/,/#StopPerftoolsEnv/d' $HOME/.bashrc
fi

cat $tmpfile >>$HOME/.bashrc
rm $tmpfile 

exit 0
