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

echo -n "Stopping nmon on "
cat ${HADOOP_HOME}/etc/hadoop/slaves | grep -v "^#" | xargs -i echo -n "{}, "
echo ""

# Kill local nmon instances
ps -ef | grep -w  nmon | grep -v grep | grep -v $0  | awk '{print $2}' | xargs -i kill -9 {}

# Stop nmon - Remote
cat ${HADOOP_HOME}/etc/hadoop/slaves | grep -v "^#" | xargs -i ssh {} "ps -ef | grep nmon | grep -v $0 | grep -v grep | awk '{print \$2}' | xargs -i kill -9 \{\}"
sleep 5

NMON_REMOTE_REC_DIR=nmonData
cat ${HADOOP_HOME}/etc/hadoop/slaves | grep -v "^#" | xargs -i ssh {} "mkdir -p ${NMON_REMOTE_REC_DIR}"

# Copy nmon logs to local
# cat ${HADOOP_HOME}/etc/hadoop/slaves | xargs -i ssh {} "ls -lrt | tail -n 1 | awk '{print \$9}' | xargs -i scp \{\} baidu@n001:$CUR_NMON_DIR"

for slaves in `cat ${HADOOP_HOME}/etc/hadoop/slaves | grep -v "^#" `
do
	nmon_rec=`ssh $slaves "ls -rt ${NMON_REMOTE_REC_DIR}/*.nmon | tail -n 1 "`
	scp ${slaves}:${nmon_rec} $CUR_NMON_DIR
done

cd ${CUR_NMON_DIR}
mkdir -p ${CUR_NMON_DIR}/nmonLogs.$$
mv *.nmon ${CUR_NMON_DIR}/nmonLogs.$$
tar czf ./nmonLogs_$$.tgz ./nmonLogs.$$
echo "Nmon Logs are tar'd and placed in ${CUR_NMON_DIR}/nmonLogs_$$.tgz"
cd -
