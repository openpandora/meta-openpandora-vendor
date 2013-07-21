#!/bin/sh

OP_CHECKFILE='/etc/pandora/first-boot'
OP_FIRSTRUN='xinit /usr/pandora/scripts/first-run-wizard.sh'

[ -f $OP_CHECKFILE ] && echo -e "\nOP_STARTUP: $OP_CHECKFILE exists, not first boot." || $OP_FIRSTRUN
