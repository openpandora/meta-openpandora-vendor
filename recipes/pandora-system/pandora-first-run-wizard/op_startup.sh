#!/bin/sh

OP_CHECKFILE='/etc/bootup.cfg'
OP_FIRSTRUN='xinit /usr/pandora/scripts/first-run-wizard.sh'


[ -f $OP_CHECKFILE ] && echo "OP_STARTUP: $OP_CHECKFILE exists, not first boot." || $OP_FIRSTRUN
