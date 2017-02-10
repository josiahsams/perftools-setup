#!/bin/bash

if [ $# -ne 1 ]; then
        echo "Usage: $0 <dirname>"
        exit 25
fi


mkdir -p $1/wdir
CUR_OPROF_DIR=`readlink -f $1/wdir`

cd $CUR_OPROF_DIR
mkdir -p $CUR_OPROF_DIR/oprof_logs/

LOGFILE=$CUR_OPROF_DIR/oprof_logs/install_log.$$

echo "Logs will be placed under $LOGFILE "

sudo apt-get -y update >> ${LOGFILE}  2>&1

echo "Installing libpapi-dev"
sudo apt-get -y install libpapi-dev >> ${LOGFILE}  2>&1

echo "Installing libpfm4-dev"
sudo apt-get -y install libpfm4-dev >> ${LOGFILE}  2>&1

echo "Installing libopt-dev"
sudo apt-get -y install libpopt-dev:ppc64el >> ${LOGFILE}  2>&1

echo "Installing binutils-dev"
sudo apt-get -y install binutils-dev >> ${LOGFILE}  2>&1

echo "Installing g++"
sudo apt-get -y install g++ >> ${LOGFILE}  2>&1

echo "Installing gcc"
sudo apt-get -y install gcc >> ${LOGFILE}  2>&1

echo "Installing libiberty-dev"
sudo apt-get -y install libiberty-dev >> ${LOGFILE}  2>&1

echo "Installing make"
sudo apt-get -y install make >> ${LOGFILE}  2>&1


if [[ ! -d $CUR_OPROF_DIR/oprofile-1.1.0 ]]; then

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

exit 0










