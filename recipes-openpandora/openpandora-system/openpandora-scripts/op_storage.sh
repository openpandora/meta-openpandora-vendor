#!/bin/bash

mountmassstorage()
{
	selection2=$(echo "$selection" | sed 's/ /\\\\040/g')
	options=$(grep "${selection2}" /proc/mounts | awk '{print $4}' | sed "s/,codepage=[A-Za-z0-9]*,/,/g" | sed 's/\\040/\\ /g' )
	device=$(grep "${selection2}" /proc/mounts | awk '{print substr($1,1,12)}')
	device2=$(grep "${selection2}" /proc/mounts | awk '{print $1}')

	if ! umount $device2; then
		zenity --title="Error" --error --text="Error.\nThe card could not be unmounted.\n\nPlease make sure to close any programs that currently access the SD Card." --timeout 10
		return 1
	fi

	delay=0

	# remove other gadget modules
	modules="$(lsmod | awk '{print $1}' | xargs echo)"
	blacklist="g_zero g_audio g_ether g_serial g_midi gadgetfs g_file_storage
		g_mass_storage g_printer g_cdc g_multi g_hid g_dbgp g_nokia g_webcam g_ncm g_acm_ms"
	restore_list=""
	for mod in $modules; do
		if echo $blacklist | grep -q "\<$mod\>"; then
			restore_list="$restore_list $mod"
			rmmod $mod
			delay=1 # enough?
		fi
	done

	# driver race condition workaround (some kernels crash without wait)
	sleep $delay

	# switch to mass storage
	modprobe g_file_storage file=$device stall=0 removable=1

	zenity --title="Mass Storage Mode" --info --text="SD Card $selection is currently in Mass Storage Mode.\n\nClick on OK when you're finished with your data transfer\nand want to go back to normal mode."

	rmmod g_file_storage

	if [ ! -d "$selection" ]; then
		mkdir "$selection"
	fi 
	mount $device2 "$selection" -o $options

	if [ -n "$restore_list" ]; then
		sleep $delay
		modprobe $restore_list
	fi
}


if [ -z $1 ]; then
	while selection=$(grep "/dev/mmcblk" /proc/mounts | cut -f 2 -d " " | sed 's/\\040/ /g' | zenity --title="SD Card Mass Storage" --width="380" --height="200" --list --text="Enable mass storage" --column="Select card"); do
		mountmassstorage
	done
else

	if [ "$1" == "list" ]; then
		grep "/dev/mmcblk" /proc/mounts | cut -f 2 -d " " | sed 's/\\040/ /g'
	else
		selection=$1
		mountmassstorage
	fi
fi

