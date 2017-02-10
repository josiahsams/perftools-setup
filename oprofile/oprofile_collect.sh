#!/bin/sh

if [ $# -ne 1 ]; then
        echo "Usage: $0 <dirname>"
        exit 25
fi

OPPATH=$1/oprofile_install/bin

cd $1

CUR_OPROF_DIR=`readlink -f $1`

mkdir -p $CUR_OPROF_DIR/oprof_logs/

LOGFILE=$CUR_OPROF_DIR/oprof_logs/collect_log.$$

sudo rm -rf $CUR_OPROF_DIR/oprofile_data/* 

sudo $OPPATH/operf -s -e CYCLES:1000000 >> $LOGFILE 2>&1

mkdir -p report 

rm -rf $CUR_OPROF_DIR/report/*

HOSTNAME=`hostname`

./oprofile_install/bin/opreport > report/${HOSTNAME}_out-report 2>$LOGFILE
./oprofile_install/bin/opreport --symbols > report/${HOSTNAME}_out-report--symbols 2>$LOGFILE

exit 0


