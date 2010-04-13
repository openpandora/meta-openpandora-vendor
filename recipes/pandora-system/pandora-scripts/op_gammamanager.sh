#!/bin/bash


if selection=$(cat /etc/pandora/conf/gamma.conf | awk -F\; '{print $1 "\n" $2 }' | zenity --width=700 --height=400 --title="Gamma Manager" --list --column "Name" --column "Description" --text "Please select a Gamma Profile" ); then
echo $selection


gamma=$(grep "$selection" /etc/pandora/conf/gamma.conf | awk -F\; '{print $3}')

if [ ${gamma} = "syssyscreatenew" ]; then
    cat /sys/devices/platform/omap2_mcspi.1/spi1.1/gamma > /tmp/gamma.current
    op_gammatool
    if zenity --question --title="Confirm new gamma setting" --text="Do you want to keep the current gamma setting or revert to the previous one?" --ok-label="Keep it" --cancel-label="Revert"; then
       if zenity --question --title="Save as profile" --text="Do you want to save the new gamma setting as new profile?\n\nNote: You can also test it out first and save it later by restarting the Gamma Manager" --ok-label="Save it now" --cancel-label="Don't save it now"; then    
         while ! name=$(zenity --title="Save current settings" --entry --text "Please enter a Name for the new profile.") || [ "x$name" = "x" ] ; do
	    zenity --title="Error" --error --text="Please enter a name for the profile.." --timeout 6
         done
         curr=$(cat /sys/devices/platform/omap2_mcspi.1/spi1.1/gamma)
         desc=$(zenity --title="Save current settings" --entry --text "Please enter a description for the new profile.")
         echo "$name;$desc;$curr" >> /etc/pandora/conf/gamma.conf    
         zenity --info --title="Profile created" --text "The current gamma settings have been saved as a new profile." --timeout 6
       fi
     else
       cat /tmp/gamma.current > /sys/devices/platform/omap2_mcspi.1/spi1.1/gamma
     fi
elif [ ${gamma} = "syssyssavecurrent" ]; then
    curr=$(cat /sys/devices/platform/omap2_mcspi.1/spi1.1/gamma)
    while ! name=$(zenity --title="Save current settings" --entry --text "Please enter a Name for the new profile.") || [ "x$name" = "x" ] ; do
	    zenity --title="Error" --error --text="Please enter a name for the profile.." --timeout 6
    done
    desc=$(zenity --title="Save current settings" --entry --text "Please enter a description for the new profile.")
    echo "$name;$desc;$curr" >> /etc/pandora/conf/gamma.conf    
    zenity --info --title="Profile created" --text "The current gamma settings have been saved as a new profile." --timeout 6
elif [ ${gamma} = "syssysdeleteprofile" ]; then    
    if selection2=$(cat /etc/pandora/conf/gamma.conf | grep -v syssys | awk -F\; '{print $1 "\n" $2 }' | zenity --width=700 --height=400 --title="Delete gamma profile" --list --column "Name" --column "Description" --text "Please select a Gamma Profile to Delete" ); then
       if zenity --question --title="Confirm Profile Removal" --text="Are you REALLY sure you want to remove the profile $selection2?\n\nThere will be NO other confirmation and this can NOT be undone!" --ok-label="Yes, remove the profile!" --cancel-label="Don't remove the profile"; then
	  remove=$(grep "$selection2" /etc/pandora/conf/gamma.conf)
          cat /etc/pandora/conf/gamma.conf | grep -v "$remove" > /tmp/gamma.conf
	  mv /tmp/gamma.conf /etc/pandora/conf/gamma.conf
	  zenity --info --title="Profile deleted" --text "The profile has been deleted." --timeout 6
       else
          zenity --info --title="Profile not deleted" --text "The profile has not been deleted." --timeout 6
       fi
    fi
else
echo $gamma > /sys/devices/platform/omap2_mcspi.1/spi1.1/gamma
fi
fi