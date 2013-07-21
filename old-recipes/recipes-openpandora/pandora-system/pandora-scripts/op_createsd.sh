#!/bin/bash
if selection=$(grep "/dev/mmcblk" /proc/mounts | cut -f 2 -d " " | sed 's/\\040/ /g' | zenity --title="Create Pandora SD Card" --width="380" --height="250" --list --text="This utility creates the needed Pandora directories on your SD Card.\nYou can also use it to format your SD Card.\n\nPlease select the SD Card to be used (no data will be changed yet):" --column="Select card"); then
selection2=$(echo "$selection" | sed 's/ /\\\\040/g')
device=$(grep "${selection2}" /proc/mounts | awk '{print $1}')

 	        if zenity --question --title="Format SD Card" --text="Do you also want to format your SD Card?\n\nNote: This will delete ALL existing data on the card!" --ok-label="Yes, format the card!" --cancel-label="Don't format it"; then
			if label=$(zenity --title="Enter label" --entry --text "Please enter a Label for your SD Card.") ; then
				name="${label// /_}"
				echo Label: $name
			else
				name=PANDORA
				echo Label: $name
			fi
			if fstype=$(zenity --title="Filesystem" --width="350" --height="320" --list --column "fs" --column "Please select" --hide-column=1 --text="The Pandora supports the following file systems.\n\nIt is strongly recommended to use VFAT (FAT32)\nto ensure a maximum compatibility with other devices.\nOnly select a different filesystem if you know what you're doing.\n" "vfat" "VFAT (FAT32), recommended." "ext2" "ext2" "ext3" "ext3" "ext4" "ext4" --ok-label="Select filesystem" ); then
				echo FS: $fstype
			else
				fstype=vfat
				echo FS: $fstype
			fi
 			if zenity --question --title="Confirm Pandora SD Card Creation" --text="The Pandora will now format your SD Card and create all the needed directories.\n\nALL EXISTING DATA WILL BE DELETED!\n\nPlease confirm the following selection:\nThe card will be formatted with $fstype and labelled $name.\n" --ok-label="Yes, do it" --cancel-label="Don't do it"; then
		  		if gksudo umount $device; then
					(
					case $fstype in
						"vfat")
						gksudo "mkfs.vfat -F 32 -n "$name" $device"
					;;
						"ext2") 
						gksudo "mkfs.ext2 -L "$name" $device"
					;;
						"ext3")
						gksudo "mkfs.ext3 -L "$name" $device"
					;;
						"ext4")
						gksudo "mkfs.ext4 -L "$name" $device"
					;;
					esac
				sync
				gksudo mkdir /tmp/mnt
				if gksudo mount $device /tmp/mnt; then
						user=$(cat /tmp/currentuser)
						gksudo mkdir /tmp/mnt/pandora
						gksudo mkdir /tmp/mnt/pandora/menu
						gksudo mkdir /tmp/mnt/pandora/apps
						gksudo mkdir /tmp/mnt/pandora/desktop
						gksudo mkdir /tmp/mnt/pandora/appdata
						echo -e "Place all PNDs that should appear in the menu into the menu-subfolder.\nPlace all PNDs that should appear on the desktop in the desktop-subfolder.\nPlace all PNDs that should appear both on the desktop AND in the menu into the apps-subfolder.\n\nPNDs will save their configuration into the appdata-subfolder." > /tmp/README.txt
						gksudo cp /tmp/README.txt /tmp/mnt/pandora
						gksudo "chown -R $user:users /tmp/mnt"				
						sync
						gksudo umount $device
						gksudo rmdir /tmp/mnt	
						zenity --info --title="Directories created" --text "The needed directories have been created.\n\nPlease put your PNDs into:\n\\\pandora\\\menu\n\\\pandora\\\desktop\n\\\pandora\\\apps\n\nPlease remove and reinsert the card to remount it.\n"

				else
					zenity --title="Error" --error --text="Error.\nThe card could not be remounted, something probably went wrong formatting it.\n\nPlease remove and reinsert the card and try again." --timeout 10
				fi
				) |
						zenity --progress \
						--title="Formatting..." \
						--text="Creating the SD Card...\nPlease wait a while..." \
						--pulsate
			
				else
					zenity --title="Error" --error --text="Error.\nThe card could not be unmounted.\n\nPlease make sure to close any programs that currently access the SD Card." --timeout 10
				fi
			fi
			
		else
			if zenity --question --title="Confirm Pandora SD Card Creation" --text="The Pandora will now create all the needed directories on your SD Card.\n\nNo existing data will be deleted.\n\nPlease confirm the creation of the directories.\n" --ok-label="Yes, do it" --cancel-label="Don't do it"; then
				mkdir $selection2/pandora
				mkdir $selection2/pandora/menu
				mkdir $selection2/pandora/apps
				mkdir $selection2/pandora/desktop
				mkdir $selection2/pandora/appdata
				echo -e "Place all PNDs that should appear in the menu into the menu-subfolder.\nPlace all PNDs that should appear on the desktop in the desktop-subfolder.\nPlace all PNDs that should appear both on the desktop AND in the menu into the apps-subfolder.\n\nPNDs will save their configuration into the appdata-subfolder." > /tmp/README.txt
				gksudo "cp /tmp/README.txt /$selection2/pandora"
				zenity --info --title="Directories created" --text "The needed directories have been created.\n\nPlease put your PNDs into:\n\\\pandora\\\menu\n\\\pandora\\\desktop\n\\\pandora\\\apps\n"
			else
				 --title="Aborted" --error --text="The directories will not be created." --timeout 10
					 
			fi
		fi
fi
