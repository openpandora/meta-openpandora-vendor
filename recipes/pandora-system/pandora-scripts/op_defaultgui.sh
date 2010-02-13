#!/bin/sh

# Select the default interface.

while ! launcher=$(zenity --list --title="Default User Interface" --text="Please choose your default application launcher." --column "return" --print-column=1 --hide-column=1 --column "Pick a launcher" "xfce" "Desktop environment (Xfce)" "pmenu" "Gaming-console like launcher (PMenu)") || [ "x$launcher" = "x" ]; do 
	zenity --title="Error" --error --text="Please select a default launcher." --timeout 6
done

if [ $launcher == "xfce" ]; then 
#	sed -i 's/.*sessions .*/sessions xfce4,pmenu/g' /etc/slim.conf
	sed -i 's/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=startxfce4/g' ~/.xinitrc
	echo Xfce selected as default interface
else
#	sed -i 's/.*sessions .*/sessions pmenu,xfce4/g' /etc/slim.conf
	sed -i 's/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=pmenu/g' ~/.xinitrc
	echo PMenu selected as default interface
fi

# Set the correct user for Autologin and enable / disable it.

if zenity --question --title="Autologin" --text="Do you wish to automatically login at startup?\n\nSecurity warning: This skips the password check on startup" --ok-label="Yes" --cancel-label="No"; then      	
	# echo "PREFERED_USER=$username" > /etc/default/autologin
	sudo sed -i 's/.*auto_login.*/auto_login yes/g' /etc/slim.conf
else
	sudo sed -i 's/.*auto_login.*/auto_login no/g' /etc/slim.conf
	fi
fi

# ----
