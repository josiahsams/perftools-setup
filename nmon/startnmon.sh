#!/bin/bash

if [ $# -ne 1 ]; then
        echo "Usage: $0 <dirname>"
        exit 25
fi

${HADOOP_HOME?"HADOOP_HOME not initialized. Check .bashrc file"} 2>/dev/null

N_DIR=$1

mkdir -p ${N_DIR}

# Get the full path of the newly created directory
CUR_NMON_DIR=`readlink -f ${N_DIR}`

echo -n "Starting nmon on "
cat ${HADOOP_HOME}/etc/hadoop/slaves | xargs -i echo -n "{}, "
echo ""

# Stop nmon - Remote 
cat ${HADOOP_HOME}/etc/hadoop/slaves | xargs -i ssh {} "ps -ef | grep nmon | grep -v grep | awk '{print \$2}' | xargs -i kill -9 \{\}"
sleep 5 

NMON_REMOTE_REC_DIR=nmonData
cat ${HADOOP_HOME}/etc/hadoop/slaves | xargs -i ssh {} "mkdir -p ${NMON_REMOTE_REC_DIR}"

# Start nmon - Remote 
cat ${HADOOP_HOME}/etc/hadoop/slaves | xargs -i ssh {} "nmon -f -m ${NMON_REMOTE_REC_DIR} -s 5 -c 10000"
sleep 5 

# Kill local nmon instances
ps -ef | grep -w  nmon | grep -v grep | awk '{print $2}' | xargs -i kill -9 {}

# Start nmon - Local
nmon -F ${CUR_NMON_DIR}/namenode.nmon -s 5 -c 5000

