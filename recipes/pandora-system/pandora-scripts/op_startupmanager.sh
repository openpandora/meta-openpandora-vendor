#!/bin/bash
# Released under the GPL
# Startup-Manager, v1.0, written by Michael Mrozek aka EvilDragon 2010 with some help by vimacs.
# This scripts allows you to change various settings of the Pandora startup process.

while mainsel=$(zenity --title="Startup manager" --width="400" --height="250" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "gui" "Change Default GUI for current user" "login" "Enable/Disable auto login" "user" "Select default user" "wifi" "Enable/Disable WiFi on boot"); do


case $mainsel in

# Change default GUI
  "gui")
    user2=$(cat /tmp/currentuser)
    selection=$(cat /etc/pandora/conf/gui.conf | awk -F\; '{print $1 "\n" $2 }' | zenity ---width=500 --height=300 --title="Change the default GUI" --list --column "Name" --column "Description" --text "Please select the GUI you want to run as default startup" )

    echo $selection

    gui=$(grep $selection /etc/pandora/conf/gui.conf | awk -F\; '{print $3}')

    if [ $gui ]; then 
      sed -i "s/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=$gui/g" /home/$user2/.xinitrc
      zenity --info --title="Changed session" --text "The default session has been changed to $selection." --timeout 6
    fi;;

# Enable / Disable Autologin 
   "login")
      if zenity --question --title="Autologin" --text="Do you wish to automatically login at startup?\n\nSecurity warning: This skips the password check on startup" --ok-label="Yes" --cancel-label="No"; then      	
	sed -i 's/.*auto_login.*/auto_login yes/g' /etc/slim.conf
	zenity --info --title="Changed auto login" --text "Auto login is now enabled." --timeout 6
      else
	sed -i 's/.*auto_login.*/auto_login no/g' /etc/slim.conf
	zenity --info --title="Changed auto login" --text "Auto login is now disabled." --timeout 6
      fi;;

# Select default user
    "user")
       if username=$(cat /etc/passwd | grep /home/ | grep -v root | awk -F\: '{print $1 }' | zenity --width=100 --height=200 --title="Select the default user" --list  --column "Username"  --text "Please select the default user\nor press Cancel to disable a default user.") ; then
         sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
	 zenity --info --title="Changed default user" --text "The default user is now $username." --timeout 6
       else
	echo
	sed -i "s/.*default_user.*/default_user/g" /etc/slim.conf
        zenity --info --title="Changed default user" --text "The default user disabled" --timeout 6
       fi;;

# Enable / Disable WiFi on boot
     "wifi")
      if zenity --question --title="Start WiFi on Bootup" --text="Do you wish to automatically start the WiFi driver on bootup?" --ok-label="Yes" --cancel-label="No"; then      	
	 ln -s ../init.d/wl1251-init /etc/rc5.d/S30wl1251-init
	 ln -s ../init.d/wl1251-init /etc/rc2.d/S30wl1251-init
	 zenity --info --title="Changed WiFi startup" --text "WiFi on boot is now enabled." --timeout 6
      else
	 rm /etc/rc2.d/S30wl1251-init
         rm /etc/rc5.d/S30wl1251-init
         zenity --info --title="Changed WiFi startup" --text "WiFi on boot is now disabled." --timeout 6
      fi;;
esac
done 