#!/bin/sh
#
# Released under the GPL

INTERFACE="`hciconfig | grep "^hci" | cut -d ':' -f 1`"
LOCK="~/.op_btenabled"

if [ $1 = "startup" ]; then
	[ -f "$LOCK" ] && sudo /usr/sbin/hciconfig "$INTERFACE" up pscan 1>/dev/null && sudo /usr/sbin/bluetoothd || echo "Bluetooth: User has not enabled Bluetooth." 

else
	
	# Figure out if Bluetooth is running or not
	
	if hciconfig "$INTERFACE" | grep UP &>/dev/null
	then
		notify-send -u normal "Bluetooth" "Bluetooth is being disabled..." -i blueman -t 5000
		sudo /usr/sbin/hciconfig ${INTERFACE} down 1>/dev/null
		rm -f "$LOCK"
	else
		pgrep bluetoothd
		echo $INTERFACE
                if [ $? -ne 1 ]; then
			notify-send -u normal "Bluetooth" "Bluetooth is being enabled..." -i blueman -t 5000
			sudo /usr/sbin/hciconfig ${INTERFACE} down 1>/dev/null
			sudo /usr/sbin/hciconfig ${INTERFACE} up pscan 1>/dev/null
			sudo /usr/sbin/bluetoothd 1>/dev/null
			touch "$LOCK"

		fi
	fi
fi
