#!/bin/bash

${WORKDIR?"Need to set WORKDIR env"} 2>/dev/null
${HADOOP_HOME?"Need to set HADOOP_HOME env"} 2>/dev/null

echo "Stopping oprofile on all nodes of the cluster"
AN "ps -ef | grep -w  'sudo.*operf' | grep -v grep | awk '{print \$2}' | xargs -i sudo kill -SIGINT {}"

sleep 30

OPROF_WDIR="$WORKDIR/perftools-setup/oprofile/wdir"

cd $OPROF_WDIR

mkdir -p all_reps/report.$$

for slaves in `cat $HADOOP_HOME/etc/hadoop/slaves | grep -v "^#" `
do
	mkdir -p all_reps/report.$$/$slaves/oprofile_data/samples
	scp -rp ${slaves}:$OPROF_WDIR/report/* $OPROF_WDIR/all_reps/report.$$/$slaves >/dev/null
        scp -rp ${slaves}:$OPROF_WDIR/oprofile_data $OPROF_WDIR/all_reps/report.$$/$slaves >/dev/null
done

mkdir -p ./all_reps/report.$$/`hostname`
cp -rp oprofile_data ./all_reps/report.$$/`hostname`/ 
mv ./report/* ./all_reps/report.$$/`hostname`/

cd all_reps

tar -czf report.$$.tgz ./report.$$

echo "oprofile logs for the cluster can be found at $OPROF_WDIR/all_reps/report.$$.tgz"

