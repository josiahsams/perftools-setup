# perftools-setup

## nmon recording.

### Pre-requisities:
1. HADOOP YARN Setup should be completed and HADOOP_HOME should be set in the environment variable.
2. Make sure the nodes are set for password-less SSH both ways(master->slaves & slaves->master).
3. Since we use the environment variables a lot in our scripts, make sure to comment out the portion following this statement in your ~/.bashrc , 
`If not running interactively, don't do anything`
4. Kindly refer to the setups & scripts provided in https://github.com/kmadhugit/hadoop-cluster-utils before proceeding further as the utility scripts provided in the repository are needed here.

### Installations:

* Monitoring utility `nmon` is required to collect performance data. To install nmon follows the steps,

  ```bash
  # Ubuntu
  sudo apt-get install nmon
  
  #RHEL
  yum install epel-release
  yum install nmon
  ```
  
### Steps:

1. After cloning this repository, add this repository to the PATH so that the scripts provided by the repository can be invoked in other scripts easily.

  ```bash
  git clone https://github.com/josiahsams/perftools-setup
  curpwd=`pwd`
  echo "export PATH=$PATH:${curpwd}/perftools-setup/nmon" >> ~/.bashrc
  . ~/.bashrc
  ```
  
2. Two scripts are provided for nmon recording and they can be invoked as follows,

  ```bash
  # To Start nmon recording in all the nodes of the cluster.
  
  startnmon.sh <dir_name>
  
  # To Stop nmon recording in all the nodes of the cluster.
  # This script is also capable of collecting all the nmon recordings 
  # and place it in the directory provided by user and keep it in an archive format.
  
  stopnmon.sh <dir_name>
  
  
