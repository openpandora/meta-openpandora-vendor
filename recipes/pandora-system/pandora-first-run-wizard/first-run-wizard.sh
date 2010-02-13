#!/bin/sh

# Initially based on the scripts by JohnX/Mer Project - http://wiki.maemo.org/Mer/
# Reworked for the OpenPandora - John Willis/Michael Mrozek

# You can start the wizard from the shell using 'xinit ./first-boot-init.sh'

export LANG=en_GB.UTF-8
export GTK2_RC_FILES=/usr/share/themes/Xfce/gtk-2.0/gtkrc

# Ensure there is a wheel group for sudoers to be put into.
# TODO: Do this somewhere better.
groupadd wheel

# We load up a background image here.
export WALLPAPER='/usr/share/xfce4/backdrops/op-firstrun.png'
hsetroot -center $WALLPAPER

# Default error message (should a user hit cancel, validation fail etc.).
ERROR_WINDOW='zenity --title="Error" --error --text="Sorry! Please try again." --timeout 6'

RESET_ROOT="yes"

# Greet the user.

zenity --info --title="Pandoras Box has been opened." --text="Welcome!\n\nPandora's Box has been opened.\n\nThis wizard will help you setting up your new OpenPandora handheld before the first use.\n\nYou will be asked a few simple questions to personalise and configure your device for use." --timeout 45

# ----

# Reset ROOT's password to something random 

# (I know the image build sets the password to something pusdo-random)
# (ok, urandom is not 100% secure but it's good enough for our needs)

if [ $RESET_ROOT == "yes" ]; then
	rootpwd=$(cat /dev/urandom|tr -dc "a-zA-Z0-9-_\$\?"|fold -w 30|head -n 1)
passwd "root" <<EOF
$rootpwd
$rootpwd
EOF
	rootpwd=""
fi

# ----

# Ask the user to calibrate the touchscreen.

#if zenity --question --title="Touchscreen calibration" --text="It is recommended to calibrate and test the device touchscreen.\n\nDo you wish to calibrate the touchscreen now?" --ok-label="Yes" --cancel-label="No"; then 
#	# Make sure we have a sane environment as this script will be run long before any /etc/profile stuff.
#	. /etc/profile.d/tslib.sh
#	# Delete the pointercal file (do we want to do that?)
#	# rm /etc/pointercal
#	# Spawn the ts_* tools as subprocesses that will return to the script.
#	echo Running ts_calibrate	
#	/usr/bin/ts_calibrate
#	wait
#	echo Running ts_test
#	/usr/bin/ts_test
#	wait
#fi

# ----

# Setup swap partition if the user has placed an SD with a swap partition on it.

#swap_part=$(sfdisk -l /dev/mmcblk? | grep swap | cut -d" " -f1)
#if [ x$swap_part != x ] ; then
#	use_swap=$(zenity --title="Enable swap?" --text "Swap partition found on SD card. Would you like to use it?\n\nWarning: This SD must remain in the system to use the swap." --list --radiolist --column " " --column "Answer" TRUE "Use swap on $swap_part" FALSE "Do not use swap")
#	if [ "$use_swap" = "Use swap on $swap_part" ] ; then
#		swapon $swap_part
#       		echo "$swap_part none swap sw 0 0" >> /etc/fstab
#	fi
#fi

# ----

# Setup the full name and username.

while ! name=$(zenity --title="Please enter your full name" --entry --text "Please enter your full name.") || [ "x$name" = "x" ] ; do
	zenity --title="Error" --error --text="Please try again." --timeout 6
done

username_guess=$(echo "$name" | cut -d" " -f1 | tr A-Z a-z)

while ! username=$(zenity --title="Enter your username" --entry --text "Please choose a short username.\n\nIt should be all lowercase and contain only letters and numbers." --entry-text "$username_guess") || [ "x$username" = "x" ] ; do
	zenity --title="Error" --error --text="Please try again." --timeout 6
done

while ! useradd -c "$name,,," -G adm,audio,video,netdev,wheel,plugdev,users "$username" ; do
	username=$(zenity --title="Please check username" --entry --text "Please ensure that your username consists of only\nletters and numbers and is not already in use on the system." --entry-text "$username")
done

# ----

# Setup the users password.

password=""
while [ x$password = x ] ; do
	password1=$(zenity --title=Password --entry --text="Please choose a new password." --hide-text)
	password2=$(zenity --title=Confirm --entry --text="Confirm your new password." --hide-text)
	if [ $password1 != $password2 ] ; then 
		zenity --title="Error" --error --text="The passwords do not match.\n\nPlease try again." --timeout 6
	else 
		if [ x$password1 = x ] ; then
			zenity --title="Error" --error --text="Password cannot be blank!\n\nPlease try again." --timeout 6
		else
			password=$password1
		fi
	fi
done

passwd "$username" <<EOF
$password
$password
EOF

# ----

# Pick a name for the OpenPandora.

while ! hostname=$(zenity --title="Name your Pandora" --entry --text "Please choose a name for your OpenPandora.\n\nIt should only contain letters, numbers and dashes." --entry-text "$username-openpandora") || [ "x$hostname" = "x" ]; do 
	zenity --title="Error" --error --text="Please try again."
done

echo $hostname > /etc/hostname
echo "127.0.0.1 localhost.localdomain localhost $hostname" > /etc/hosts
hostname -F /etc/hostname

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

while ! launcher=$(zenity --list --title="Default User Interface" --text="Please choose your default application launcher.\n\nYou can always change this setting later." --column "return" --print-column=1 --hide-column=1 --column "Pick a launcher" "xfce" "Desktop environment (Xfce)" "pmenu" "Gaming-console like launcher (PMenu)") || [ "x$launcher" = "x" ]; do 
	zenity --title="Error" --error --text="Please select a default launcher." --timeout 6
done

if [ $launcher == "xfce" ]; then 
#	sed -i 's/.*sessions .*/sessions xfce4,pmenu/g' /etc/slim.conf
	sed -i 's/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=startxfce4/g' /home/$username/.xinitrc
	echo Xfce selected as default interface
else
#	sed -i 's/.*sessions .*/sessions pmenu,xfce4/g' /etc/slim.conf
	sed -i 's/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=pmenu/g' /home/$username/.xinitrc
	echo PMenu selected as default interface
fi

# ----

# Set the timezone and date/time

while ! timezone=$(zenity --list --title "Select your timezone" --text="Please select your timezone" --column="Select your timezone" --print-column=1 "GMT (London, Lisbon, Portugal, Casablanca, Morocco)" "GMT+1 (Paris, Berlin, Amsterdam, Bern, Stockholm)" "GMT+2 (Athens, Helsinki, Istanbul)" "GMT+3 (Kuwait, Nairobi, Riyadh, Moscow)" "GMT+4 (Abu Dhabi, Iraq, Muscat, Kabul)" "GMT+5 (Calcutta, Colombo, Islamabad, Madras, New Delhi)" "GMT+6 (Almaty, Dhakar, Kathmandu)" "GMT+7 (Bangkok, Hanoi, Jakarta)" "GMT+8 (Beijing, Hong Kong, Kuala Lumpar, Singapore, Taipei)" "GMT+9 (Osaka, Seoul, Sapporo, Tokyo, Yakutsk)" "GMT+10 (Brisbane, Melbourne, Sydney, Vladivostok)" "GMT+11 (Magadan, New Caledonia, Solomon Is)" "GMT+12 (Auckland, Fiji, Kamchatka, Marshall Is., Wellington, Suva)" "GMT-1 (Azores, Cape Verde Is.)" "GMT-2 (Mid-Atlantic)" "GMT-3 (Brasilia, Buenos Aires, Georgetown)" "GMT-4 (Atlantic Time, Caracas)" "GMT-5 (Bogota, Lima, New York)" "GMT-6 (Mexico City, Saskatchewan, Chicago, Guatamala)" "GMT-7 (Denver, Edmonton, Mountain Time, Phoenix, Salt Lake City)" "GMT-8 (Anchorage, Los Angeles, San Francisco, Seattle)" "GMT-9 (Alaska)" "GMT-10 (Hawaii, Honolulu)" "GMT-11 (Midway Island, Samoa)" "GMT-12 (Eniwetok, Kwaialein)" "UTC" "Universal" --width=500 --height=450) || [ "x$timezone" = "x" ] ; do
	zenity --title="Error" --error --text="Please select a timezone." --timeout=6
done
timezone=`echo $timezone | sed  's/(.*)//g'`
echo $timezone
echo rm /etc/localtime && ln -s /usr/share/zoneinfo/Etc/$timezone /etc/localtime

#Make sure we clean up any leading zeros in the day (as Zenity freaks out)
date_d=`date +%d | sed 's/^0//'`
date_m=`date +%m`
date_y=`date +%Y`

while ! date=$(zenity --calendar --text="Please select the current date" --title "Please select the current date" --day=$date_d --month=$date_m --year=$date_y --date-format="%Y%m%d" --width=500) || [ "x$date" = "x" ] ; do
        zenity --title="Error" --error --text="Please select the date." --timeout 6
done

echo $date

time_h=`date +%H`
time_m=`date +%M`

while ! time=$(zenity --title="Enter actual time" --entry --text "Please enter the time in 24hour format (HH:MM):" --entry-text "$time_h:$time_m") || [ "x$time" = "x" ] ; do
        zenity --title="Error" --error --text="Please input the time." --timeout 6
done

while ! date -d $time ; do
	time=$(zenity --title="Enter actual time" --entry --text "Please enter the time in 24hour format (HH:MM):" --entry-text "$time_h:$time_m")
done
 
date +%Y%m%d -s $date
date +%H:%M -s $time

# ----

# Finsh up and boot the system.

zenity --info --title="Finished" --text "This concludes the First Boot Wizard.\n\nYour chosen interface will start in a few seconds\n\nThankyou for buying the OpenPandora. Enjoy using the device!" --timeout 6

# ----

# Write the control file so this script is not run on next boot 
# (hackish I know but I want the flexability to drop a new script in later esp. in the early firmwares).

touch /etc/pandora/first-boot
# Make the control file writeable by all to allow the user to delete to rerun the wizard on next boot.
chmod 0666 /etc/pandora/first-boot

# ----
