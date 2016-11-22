#!/bin/bash

echo -n "Starting oprofile on all nodes of the cluster"

AN "cd $HOME/oprofile; ./oprofile_collect.sh $HOME/oprofile > /dev/null 2>&1 &"







