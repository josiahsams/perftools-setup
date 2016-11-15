#!/bin/bash

set -x

${WORKDIR?"Need to set WORKDIR env"} 2>/dev/null
type AN >/dev/null 2>&1 || { echo >&2 "Require AN script to be in path. Aborting."; exit 1; }
type DN >/dev/null 2>&1 || { echo >&2 "Require DN script to be in path. Aborting."; exit 1; }
type CP >/dev/null 2>&1 || { echo >&2 "Require CP script to be in path. Aborting."; exit 1; }

DN "mkdir -p $HOME/perftools-setup/oprofile/"

CP $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh
CP $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh
AN "chmod +x $WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh"
AN "chmod +x $WORKDIR/perftools-setup/oprofile/oprofile_collect.sh"

AN "$WORKDIR/perftools-setup/oprofile/oprofile_ubuntu_installer.sh $WORKDIR"

exit 0



