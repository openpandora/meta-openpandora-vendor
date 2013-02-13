#!/bin/sh

kernel_major=`uname -r | cut -c 1`
if [ "$kernel_major" = "2" ]; then
	# new kernel only (for now)
	exit 0
fi

if [ "$1" = "1" ]; then
	if [ ! -e /sys/class/gpio/gpio15/value ]; then
		echo 15 > /sys/class/gpio/export
		sleep 0.2
		echo out > /sys/class/gpio/gpio15/direction
	fi
	echo 0 > /sys/devices/platform/omap_uart.0/sleep_timeout
	echo 1 > /sys/class/gpio/gpio15/value
	hciattach /dev/ttyO0 texasalt 3000000
	INTERFACE="`hciconfig | grep "^hci" | cut -d ':' -f 1`"
	if [ -z "$INTERFACE" ]; then
		killall hciattach
		echo 0 > /sys/class/gpio/gpio15/value
		exit 1
	fi
	echo 255 > '/sys/class/leds/pandora::bluetooth/brightness'
	exit 0
elif [ "$1" = "0" ]; then
	killall hciattach
	echo 0 > /sys/class/gpio/gpio15/value
	echo 0 > '/sys/class/leds/pandora::bluetooth/brightness'
	echo 10 > /sys/devices/platform/omap_uart.0/sleep_timeout
	exit 0
else
	echo "invalid argument"
	exit 1
fi

