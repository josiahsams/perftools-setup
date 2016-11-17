#!/bin/bash

if [ $# -ne 1 ]; then
        echo "Usage: $0 <dirname>"
        exit 25
fi


mkdir -p $1/oprofile
CUR_OPROF_DIR=`readlink -f $1/oprofile`

cd $CUR_OPROF_DIR
mkdir -p $CUR_OPROF_DIR/oprof_logs/

LOGFILE=$CUR_OPROF_DIR/oprof_logs/install_log.$$

#using a log file during installation is a problem. discuss

echo "Logs will be placed under $LOGFILE "

echo "Installing papi-devel"
sudo yum -y install papi-devel >> ${LOGFILE}  2>&1

echo "Installing libpfm-devel"
sudo yum -y install libpfm-devel

echo "Installing popt-devel"
sudo yum -y install popt-devel

echo "Installing binutils"
sudo yum -y install binutils-devel >> ${LOGFILE}  2>&1

echo "Installing gcc-c++"
sudo yum -y install gcc-c++ >> ${LOGFILE}  2>&1

if [[ ! -d $WORKDIR/oprofile/oprofile-1.1.0 ]]; then

	rm -f oprofile-1.1.0.tar.gz

	echo "Downloading from http://prdownloads.sourceforge.net/oprofile/oprofile-1.1.0.tar.gz"
	wget http://prdownloads.sourceforge.net/oprofile/oprofile-1.1.0.tar.gz  >> ${LOGFILE}  2>&1

	echo "Extracting oprofile source from tar file"
	tar -zxf oprofile-1.1.0.tar.gz  >> ${LOGFILE}  2>&1

	echo "Compiling and installing oprofile from source dir oprofile-1.1.0"
	cd oprofile-1.1.0
	./configure --prefix=$CUR_OPROF_DIR/oprofile_install --with-java=$JAVA_HOME  >> ${LOGFILE}  2>&1

	make  >> ${LOGFILE}  2>&1

	make install >> ${LOGFILE}  2>&1

	mkdir -p /tmp/.oprofile

	chmod 777 /tmp/.oprofile
fi

cp $1/perftools-setup/oprofile/oprofile_collect.sh $1/oprofile/

chmod +x $1/oprofile/oprofile_collect.sh

exit 0










