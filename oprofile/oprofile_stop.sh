#!/bin/bash

set -x

${WORKDIR?"Need to set WORKDIR env"} 2>/dev/null
${HADOOP_HOME?"Need to set HADOOP_HOME env"} 2>/dev/null

# Stop oprofile - Remote
if [[ -e ${HADOOP_HOME}/etc/hadoop/slaves ]]; then
echo -n "Stopping oprofile on "
cat ${HADOOP_HOME}/etc/hadoop/slaves | grep -v '^#' | xargs -i echo -n "{}, "
echo ""
cat ${HADOOP_HOME}/etc/hadoop/slaves | grep -v '^#' | xargs -i ssh {} "ps -ef | grep -w operf | grep -v grep | awk '{print \$2}' | xargs -i sudo kill -9 \{\}"
fi

# Kill local oprofile instance
ps -ef | grep -w  operf | grep -v grep | awk '{print $2}' | xargs -i sudo kill -9 {}

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

echo "Removing oprofile libraries from spark configuration"

sed -i "/^[ |\t]*spark\.executor\.extraJavaOptions.*libjvmti_oprofile\.so/s/-agentpath:\/home\/$USER\/oprofile\/oprofile_install\/lib\/oprofile\/libjvmti_oprofile\.so[:]\{0,1\}//g" $SPARK_HOME/conf/spark-defaults.conf


sed -i "/^[ |\t]*spark\.driver\.extraJavaOptions.*libjvmti_oprofile\.so/s/-agentpath:\/home\/$USER\/oprofile\/oprofile_install\/lib\/oprofile\/libjvmti_oprofile\.so[:]\{0,1\}//g" $SPARK_HOME/conf/spark-defaults.conf

sed -i "/^[ |\t]*spark\.executor\.extraLibraryPath.*oprofile_install\/lib/s/\/home\/$USER\/oprofile\/oprofile_install\/lib[:]\{0,1\}//g" $SPARK_HOME/conf/spark-defaults.conf

sed -i "/^[ |\t]*spark\.driver\.extraLibraryPath.*oprofile_install\/lib/s/\/home\/$USER\/oprofile\/oprofile_install\/lib[:]\{0,1\}//g" $SPARK_HOME/conf/spark-defaults.conf

