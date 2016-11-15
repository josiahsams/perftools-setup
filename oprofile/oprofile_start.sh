#!/bin/bash

set -x

${HADOOP_HOME?"Need to set HADOOP_HOME env"} 2>/dev/null
${SPARK_HOME?"Need to set SPARK_HOME env"} 2>/dev/null

echo "Setting up Spark configuration to use oprofile libraries"

sed -i '/^[ |\t]*#[ |\t]*spark\.executor\.extraJavaOptions.*libjvmti_oprofile\.so/s/^[ |\t]*#//g' $SPARK_HOME/conf/spark-defaults.conf
grep -v '^#'  $SPARK_HOME/conf/spark-defaults.conf | grep "spark.executor.extraJavaOptions" | grep "libjvmti_oprofile\.so"

if [ $? -ne 0 ]; then
javaopts=`grep -v '^#'  $SPARK_HOME/conf/spark-defaults.conf | grep "spark.executor.extraJavaOptions" | awk -F '[ |\t]*' '{print $2}' | awk -F '"' '{print $2}'`
sed -i '/^[ |\t]*spark\.executor\.extraJavaOptions/d' $SPARK_HOME/conf/spark-defaults.conf
if [ ! -z "$javaopts" -a "$javaopts" != " " ]; then
javaopts="-agentpath:$WORKDIR/oprofile/oprofile_install/lib/oprofile/libjvmti_oprofile.so:$javaopts"
else
javaopts="-agentpath:$WORKDIR/oprofile/oprofile_install/lib/oprofile/libjvmti_oprofile.so"
fi
echo "spark.executor.extraJavaOptions    \"$javaopts\"" >> $SPARK_HOME/conf/spark-defaults.conf
fi

sed -i '/^[ |\t]*#[ |\t]*spark\.driver\.extraJavaOptions.*libjvmti_oprofile\.so/s/^[ |\t]*#//g' $SPARK_HOME/conf/spark-defaults.conf
grep -v '^#'  $SPARK_HOME/conf/spark-defaults.conf | grep "spark.driver.extraJavaOptions" | grep "libjvmti_oprofile\.so"

if [ $? -ne 0 ]; then
javaopts=`grep -v '^#'  $SPARK_HOME/conf/spark-defaults.conf | grep "spark.driver.extraJavaOptions" | awk -F '[ |\t]*' '{print $2}' | awk -F '"' '{print $2}'`
sed -i '/^[ |\t]*spark\.driver\.extraJavaOptions/d' $SPARK_HOME/conf/spark-defaults.conf
if [ ! -z "$javaopts" -a "$javaopts" != " " ]; then
javaopts="-agentpath:$WORKDIR/oprofile/oprofile_install/lib/oprofile/libjvmti_oprofile.so:$javaopts"
else
javaopts="-agentpath:$WORKDIR/oprofile/oprofile_install/lib/oprofile/libjvmti_oprofile.so"
fi
echo "spark.driver.extraJavaOptions    \"$javaopts\"" >> $SPARK_HOME/conf/spark-defaults.conf
fi


sed -i '/^[ |\t]*#[ |\t]*spark\.executor\.extraLibraryPath.*oprofile_install\/lib/s/^[ |\t]*#//g' $SPARK_HOME/conf/spark-defaults.conf
grep -v '^#'  $SPARK_HOME/conf/spark-defaults.conf | grep "spark.executor.extraLibraryPath" | grep "oprofile_install\/lib"

if [ $? -ne 0 ]; then
libpath=`grep -v '^#'  $SPARK_HOME/conf/spark-defaults.conf | grep "spark.executor.extraLibraryPath" | awk -F '[ |\t]*' '{print $2}' | awk -F '"' '{print $2}'`
sed -i '/^[ |\t]*spark\.executor\.extraLibraryPath/d' $SPARK_HOME/conf/spark-defaults.conf
if [ ! -z "$libpath" -a "$libpath" != " " ]; then
libpath="$WORKDIR/oprofile/oprofile_install/lib:$libpath"
else
libpath="$WORKDIR/oprofile/oprofile_install/lib"
fi
echo "spark.executor.extraLibraryPath    \"$libpath\"" >> $SPARK_HOME/conf/spark-defaults.conf
fi


sed -i '/^[ |\t]*#[ |\t]*spark\.driver\.extraLibraryPath.*oprofile_install\/lib/s/^[ |\t]*#//g' $SPARK_HOME/conf/spark-defaults.conf
grep -v '^#'  $SPARK_HOME/conf/spark-defaults.conf | grep "spark.driver.extraLibraryPath" | grep "oprofile_install\/lib"

if [ $? -ne 0 ]; then
libpath=`grep -v '^#'  $SPARK_HOME/conf/spark-defaults.conf | grep "spark.driver.extraLibraryPath" | awk -F '[ |\t]*' '{print $2}' | awk -F '"' '{print $2}'`
sed -i '/^[ |\t]*spark\.driver\.extraLibraryPath/d' $SPARK_HOME/conf/spark-defaults.conf
if [ ! -z "$libpath" -a "$libpath" != " " ]; then
libpath="$WORKDIR/oprofile/oprofile_install/lib:$libpath"
else
libpath="$WORKDIR/oprofile/oprofile_install/lib"
fi
echo "spark.driver.extraLibraryPath    \"$libpath\"" >> $SPARK_HOME/conf/spark-defaults.conf
fi

if [[ -e ${HADOOP_HOME}/etc/hadoop/slaves ]]; then
echo -n "Starting oprofile on "
cat ${HADOOP_HOME}/etc/hadoop/slaves | grep -v '^#' | xargs -i echo -n "{}, "
echo ""
cat ${HADOOP_HOME}/etc/hadoop/slaves | grep -v '^#' | xargs -i ssh {} "sh -c \"cd oprofile; ./oprofile_collect.sh $HOME/oprofile > /dev/null 2>&1 &\""
fi


echo -n "Starting oprofile locally"

cd $WORKDIR/oprofile

./oprofile_collect.sh $WORKDIR/oprofile > /dev/null 2>&1 &

exit 0







