#!/bin/sh
#
# Released under the GPL

SILENT=0
while getopts s opt
do
	case "$opt" in
		s) SILENT=1;;
	esac
done

INTERFACE=`hciconfig | grep "^hci" | cut -d ':' -f 1`
pgrep bluetoothd
if [ $? = 1 ]; then
	notify-send "Bluetooth" "The bluetooth interface is being set up..." -i /usr/share/icons/hicolor/32x32/apps/st_bluetooth.png
	sudo /usr/sbin/hciconfig ${INTERFACE} down
	sudo /usr/sbin/hciconfig ${INTERFACE} up pscan
	sudo /usr/sbin/bluetoothd
fi

if [ ${SILENT} = 0 ]; then
	bluetooth-wizard
fi
