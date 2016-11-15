Profiling Java applications using Oprofile:

Pre-requisites:
1. Enable passwordless ssh and sudo as profiling data collection requires root privileges.
2. HADOOP_HOME, SPARK_HOME, JAVA_HOME and WORKDIR should be set

Installation:

On Ubuntu:

1. Create user oprofile with group oprofile on all nodes of the cluster.

addgroup oprofile
adduser --ingroup oprofile oprofile

2. Run the below oprofile installer that installs oprofile and required packages on all nodes of the cluster.

oprofile_install_AN.sh


Note: 

oprofile should be rebuild and installed every time when the system is moved to a different JDK level. The old oprofile must be uninstalled before installing the new version. 

To uninstall the old oprofile installed via make install, do

cd <path that you ran make install>
make uninstall

Steps:

1. After cloning this repository, add this repository to the PATH so that the scripts provided by the repository can be invoked in other scripts easily.

git clone https://github.com/josiahsams/perftools-setup
curpwd=`pwd`
echo "export PATH=$PATH:${curpwd}/perftools-setup/oprofile" >> ~/.bashrc
. ~/.bashrc


2. To enable oprofile for profiling spark applications:

oprofile_start.sh

3. To disable oprofile for spark applications

oprofile_stop.sh

