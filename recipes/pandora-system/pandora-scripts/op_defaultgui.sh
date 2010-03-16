#!/bin/sh

# Set the correct user for Autologin and enable / disable it.

if zenity --question --title="Autologin" --text="Do you wish to automatically login at startup?\n\nSecurity warning: This skips the password check on startup" --ok-label="Yes" --cancel-label="No"; then      	
	# echo "PREFERED_USER=$username" > /etc/default/autologin
	sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
	sed -i 's/.*auto_login.*/auto_login yes/g' /etc/slim.conf
else
	if zenity --question --title="User" --text="Do you wish to have your username automatically populated in the login screen?\n\nNote: This is ideal if your the only user of the OpenPandora but wish to disable autologin and use a password." --ok-label="Yes" --cancel-label="No"; then 
		sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
		sed -i 's/.*auto_login.*/auto_login no/g' /etc/slim.conf
	else
		sed -i "s/.*default_user.*/default_user/g" /etc/slim.conf
		sed -i 's/.*auto_login.*/auto_login no/g' /etc/slim.conf
	fi
fi

# ----

# Select the default interface and setup SLiM to pass that as a sesion to ~./.xinitrc

while ! launcher=$(zenity --height 260 --list --title="Default User Interface" --text="Please choose your default application launcher.\n\nYou can always change this setting later." --column "return" --print-column=1 --hide-column=1 --column "Pick a launcher" "xfce" "Desktop environment (Xfce)" "mmenu" "A very basic GUI (MiniMenu)" "pmenu" "Gaming-console like launcher (PMenu)" "netbooklauncher" "Ubuntu Netbook Launcher") || [ "x$launcher" = "x" ]; do 
	zenity --title="Error" --error --text="Please select a default launcher." --timeout 6
done

if [ $launcher == "xfce" ]; then 
#	sed -i 's/.*sessions .*/sessions xfce4,pmenu/g' /etc/slim.conf
	sed -i 's/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=startxfce4/g' ~/.xinitrc
	echo Xfce selected as default interface
elif [ $launcher == "pmenu" ]; then
#	sed -i 's/.*sessions .*/sessions pmenu,xfce4/g' /etc/slim.conf
	sed -i 's/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=pmenu/g' ~/.xinitrc
	echo PMenu selected as default interface
elif [ $launcher == "netbooklauncher" ]; then
	sed -i 's/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=startnetbooklauncher/g' ~/.xinitrc
elif [ $launcher == "mmenu" ]; then
	sed -i 's/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=startmmenu/g' ~/.xinitrc
fi

zenity --info --title="Changed session" --text "Thankyou, the default session has been changed." --timeout 6
