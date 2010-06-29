#!/bin/bash
while selection=$(grep "/dev/mmcblk" /proc/mounts | cut -f 2 -d " " | sed 's/\\040/ /g' | zenity --title="SD Card Mass Storage" --width="380" --height="200" --list --text="Enable mass storage" --column="Select card"); do
selection2=$(echo $selection | sed 's/ /\\\\040/g')
options=$(grep ${selection2} /proc/mounts | awk '{print $4}' | sed "s/,codepage=[A-Za-z0-9]*,/,/g" | sed 's/\\040/\\ /g' )
device=$(grep ${selection2} /proc/mounts | awk '{print substr($1,1,12)}')
device2=$(grep ${selection2} /proc/mounts | awk '{print $1}')

if umount $device
 
  then
    # switch to mass storage
   if lsmod | grep g_cdc &>/dev/null
	then
	echo Found g_cdc - removing...
	rmmod g_cdc
	ethernet=1
    fi
   modprobe g_file_storage file=$device stall=0
   zenity --title="Mass Storage Mode" --info --text="SD Card $selection is currently in Mass Storage Mode.\n\nClick on OK when you're finished with your data transfer\nand want to go back to normal mode."
    rmmod g_file_storage
    if [ $ethernet=1 ]; then
      echo Reloading g_cdc...
      modprobe g_cdc
    fi
    mount $device2 "$selection" -o $options
  else
     zenity --title="Error" --error --text="Error.\nThe card could not be unmounted.\n\nPlease make sure to close any programs that currently access the SD Card." --timeout 10
fi
done