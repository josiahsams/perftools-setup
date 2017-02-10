#!/bin/bash

${WORKDIR?"Need to set WORKDIR env"} 2>/dev/null

echo -n "Starting oprofile on all nodes of the cluster"

AN "cd $WORKDIR/perftools-setup/oprofile/wdir; ../oprofile_collect.sh $WORKDIR/perftools-setup/oprofile/wdir > /dev/null 2>&1 &"







