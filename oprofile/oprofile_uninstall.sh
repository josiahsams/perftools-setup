#!/bin/bash

set -x

${WORKDIR?"Need to set WORKDIR env"} 2>/dev/null
if [ $# -gt 1 ]; then
        echo "Usage: $0 [-r]
        exit 25
fi

if [ $# -eq 1 and $1 != "-r" ]; then
        echo "Usage: $0 [-r]
        exit 25
fi

recompile=false

if [ $# -eq 1 ]; then
	recompile=true
fi

WDIR="$WORKDIR/perftools-setup/oprofile/wdir"

FLOG="$WDIR/oprof_logs/uninstall_log.$$"

if [ ! -d $WDIR/oprofile-1.1.0 ]; then
	echo "$WDIR/oprofile-1.1.0 doesn't exist"
	exit 26
fi

cd $WDIR/oprofile-1.1.0

if [ -d $WDIR/oprofile_install ]; then
	
	make uninstall >FLOG

	make clean >FLOG

	rm -r $WDIR/oprofile_install
fi

if [ $recompile = true ]; then

	./configure -prefix=${WDIR}/oprofile_install --with-java=${JAVA_HOME} >FLOG

	make install >FLOG
fi

exit 0

