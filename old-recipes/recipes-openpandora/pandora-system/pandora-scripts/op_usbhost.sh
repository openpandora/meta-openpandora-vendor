#!/bin/sh
#
# Released under the GPL

# This script simply toggles USB Host on or off.
cd /
if [ "`lsmod | grep ehci_hcd`" ]
then
	notify-send -u normal "USB" "USB Host is being disabled..." -i /usr/share/icons/gnome/32x32/devices/usbpendrive_unmount.png
	rmmod ehci-hcd
else
	notify-send -u normal "USB" "USB Host is being enabled..." -i /usr/share/icons/gnome/32x32/devices/usbpendrive_unmount.png
	modprobe ehci-hcd
fi
