#!/bin/sh
#
# Released under the GPL

INTERFACE="`hciconfig | grep "^hci" | cut -d ':' -f 1`"
LOCK=".op_btenabled"
cd "$HOME"

if [ "$1" = "startup" ]; then
	[ -f "$LOCK" ] && sudo /usr/sbin/hciconfig "$INTERFACE" up pscan 1>/dev/null && sudo /usr/sbin/bluetoothd || echo "Bluetooth: User has not enabled Bluetooth." 

else	
	# Figure out if Bluetooth is running or not
	
	if hciconfig "$INTERFACE" | grep UP &>/dev/null
	then
		notify-send -u normal "Bluetooth" "Bluetooth is being disabled..." -i blueman -t 5000
		sudo /usr/sbin/hciconfig ${INTERFACE} down 1>/dev/null
		sudo /usr/pandora/scripts/op_bluetooth_work.sh 0
		rm -f "$LOCK"
	else
		if ! sudo /usr/pandora/scripts/op_bluetooth_work.sh 1; then
			notify-send -u normal "Bluetooth" "Bluetooth error" -i blueman -t 3000
			exit 1
		fi

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
