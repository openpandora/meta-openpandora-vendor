#!/bin/bash
# Main GUI

while mainsel=$(zenity --title="Startupmanager" --width="400" --height="250" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "gui" "Change Default GUI for current user" "login" "Enable/Disable Autologin" "user" "Select default user" "wifi" "Enable/Disable WiFi on Boot"); do

case $mainsel in

# Change default GUI
  "gui")
    user2=$(cat /tmp/currentuser)
    selection=$(cat /etc/pandora/conf/gui.conf | awk -F\; '{print $1 "\n" $2 }' | zenity ---width=500 --height=300 --title="Change the Default GUI" --list --column "Name" --column "Description" --text "Please select the GUI you want to run as default startup" )
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
	zenity --info --title="Changed Autologin" --text "Autologin is now enabled." --timeout 6
      else
	sed -i 's/.*auto_login.*/auto_login no/g' /etc/slim.conf
	zenity --info --title="Changed Autologin" --text "Autologin is now disabled." --timeout 6
      fi;;

# Select default user
    "user")
       if username=$(cat /etc/passwd | grep /home/ | grep -v root | awk -F\: '{print $1 }' | zenity --width=100 --height=200 --title="Select the default user" --list  --column "Username"  --text "Please select the default user\nor press Cancel to disable a default user.") ; then
         sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
	 zenity --info --title="Changed Default User" --text "The default user is now $username." --timeout 6
       else
	echo
	sed -i "s/.*default_user.*/default_user/g" /etc/slim.conf
        zenity --info --title="Changed Default User" --text "The default user disabeled" --timeout 6
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