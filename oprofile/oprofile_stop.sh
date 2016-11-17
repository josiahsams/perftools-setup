#!/bin/bash

${WORKDIR?"Need to set WORKDIR env"} 2>/dev/null
${HADOOP_HOME?"Need to set HADOOP_HOME env"} 2>/dev/null

echo "Stopping oprofile on all nodes of the cluster"
AN "ps -ef | grep -w  operf | grep -v grep | awk '{print \$2}' | xargs -i sudo kill -9 {}"

sleep 30

cd $WORKDIR/oprofile

mkdir -p $WORKDIR/oprofile/all_reps/report.$$

mv ./report/* ./all_reps/report.$$/

for slaves in `cat $HADOOP_HOME/etc/hadoop/slaves`
do
	scp ${slaves}:$HOME/oprofile/report/* $WORKDIR/oprofile/all_reps/report.$$/
done

cd all_reps

tar -czf report.$$.tgz ./report.$$

echo "oprofile logs for the cluster can be found at $WORKDIR/oprofile/all_reps/report.$$.tgz"

