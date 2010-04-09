#!/bin/sh
#
# Released under the GPL

# This script simply toggles internal WiFi on or off.

if [ "`lsmod | grep wl1251`" ]
then
	notify-send -u normal "WLAN" "WLAN is being disabled..." -i /usr/share/icons/hicolor/32x32/apps/nm-no-connection.png
	ifconfig wlan0 down
	rmmod board_omap3pandora_wifi wl1251_sdio wl1251
else
	notify-send -u normal "WLAN" "WLAN is being enabled..." -i /usr/share/icons/hicolor/32x32/apps/nm-device-wired.png
	/etc/init.d/wl1251-init start
fi
