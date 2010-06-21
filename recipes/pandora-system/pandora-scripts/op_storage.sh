#!/bin/bash
while mainsel=$(zenity --title="SD Card Mass Storage" --width="380" --height="200" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "sd1" "Switch SD Card 1 to Mass Storage Mode" "sd2" "Switch SD Card 2 to Mass Storage Mode" ); do
  case $mainsel in
  "sd1")
  remount=$(cat /proc/mounts | grep /dev/mmcblk0p1 | awk '{print "mount " $1 " " $2 " -o " $4}' | sed "s/,codepage=[A-Za-z0-9]*,/,/g")
  if umount /dev/mmcblk0p1
  then
    # switch to mass storage
    if lsmod | grep g_cdc &>/dev/null
	then
	echo Found g_cdc - removing...
	rmmod g_cdc
	ethernet=1
    fi
    modprobe g_file_storage file=/dev/mmcblk0p1 stall=0
    zenity --title="SD Card 1 Mass Storage Mode" --info --text="SD Card Slot 1 is currently in Mass Storage Mode.\n\nClick on OK when you're finished with your data transfer\nand want to go back to normal mode."
    rmmod g_file_storage
    if [ $ethernet=1 ]; then
      echo Reloading g_cdc...
      modprobe g_cdc
    fi
    $remount
  else
     zenity --title="Error" --error --text="Error.\nEither there is no card in SD Slot 1 or some program\nis currently accessing the card.\n\nPlease make sure to close any programs that currently access te SD Card." --timeout 6
  fi
  ;;
  "sd2")
  remount=$(cat /proc/mounts | grep /dev/mmcblk0p1 | awk '{print "mount " $1 " " $2 " -o " $4}' | sed "s/,codepage=[A-Za-z0-9]*,/,/g")
  if umount /dev/mmcblk1p1
  then
    # switch to mass storage
     if lsmod | grep g_cdc &>/dev/null
	then
	echo Found g_cdc - removing...
	rmmod g_cdc
	ethernet=1
    fi
    modprobe g_file_storage file=/dev/mmcblk1p1 stall=0
    zenity --title="SD Card 2 Mass Storage Mode" --info --text="SD Card Slot 2 is currently in Mass Storage Mode.\n\nClick on OK when you're finished with your data transfer\nand want to go back to normal mode."
    rmmod g_file_storage
    if [ $ethernet=1 ]; then
      echo Reloading g_cdc...
      modprobe g_cdc
    fi
    $remount
  else
     zenity --title="Error" --error --text="Error.\nEither there is no card in SD Slot 2 or some program\nis currently accessing the card.\n\nPlease make sure to close any programs that currently access te SD Card." --timeout 6
  fi
  ;;
  esac
done