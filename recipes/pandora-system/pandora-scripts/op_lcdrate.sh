#!/bin/sh
# LCD mode setup script
# Copyright (c) 2010, Gražvydas Ignotas
# License: BSD (http://www.opensource.org/licenses/bsd-license.php)

modedb="\
60|36000,800/68/214/1,480/39/34/1 \
50|36000,800/189/214/1,480/83/34/1"

# timings file for LCD device
timings_file="/sys/devices/platform/omapdss/display0/timings"


set -e

for mode in $modedb
do
	name=`echo $mode | awk -F '|' '{print $1}'`
	if [ "x$name" = "x$1" ]
	then
		timings=`echo $mode | awk -F '|' '{print $2}'`
		echo $timings > $timings_file
		exit 0
	fi
done

echo "$0: missing rate: $1"
exit 1
