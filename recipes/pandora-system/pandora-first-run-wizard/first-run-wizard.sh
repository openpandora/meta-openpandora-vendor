#!/bin/sh

# Based on the scripts by JohnX/Mer Project - http://wiki.maemo.org/Mer/
# Reworked for the OpenPandora - John Willis/Michael Mrozek

# You can start the wizard from the shell using 'xinit ./first-boot-init.sh'
# Maybe we run it for the first time from rc5.d and delete the symlink at the end of the script?

export LANG=en_GB.UTF-8
export GTK2_RC_FILES=/usr/share/themes/Xfce/gtk-2.0/gtkrc

# Ensure there is a wheel group for sudoers to be put into.
# TODO: Do this somewhere better.
groupadd wheel

# We load up a background image here
export WALLPAPER=/usr/share/backgrounds/op_default.png
hsetroot -center $WALLPAPER

# Greet the user
zenity --info --title="Pandoras Box has been opened." --text "Welcome. This wizard will help you setting up your new OpenPandora handheld before your first use."

# Should we really enable SWAP?
#swap_part=$(sfdisk -l /dev/mmcblk? | grep swap | cut -d" " -f1)
#if [ x$swap_part != x ] ; then
#	use_swap=$(zenity --title="Enable swap?" --text "Swap partition found. Would you like to use it?" --list --radiolist --column " " --column "Answer" TRUE "Use swap on $swap_part" FALSE "Do not use swap")
#	if [ "$use_swap" = "Use swap on $swap_part" ] ; then
#		swapon $swap_part
#       	echo "$swap_part none swap sw 0 0" >> /etc/fstab
#	fi
#fi

# First, setup the full name and username.

while ! name=$(zenity --title="Enter your name" --entry --text "Please enter your full name.") || [ "x$name" = "x" ] ; do
	zenity --title="Error" --error --text="Please try again."
done

username_guess=$(echo "$name" | cut -d" " -f1 | tr A-Z a-z)

while ! username=$(zenity --title="Enter your username" --entry --text "Please choose a short username.
It should be all lowercase and
contain only letters and numbers." --entry-text "$username_guess") || [ "x$username" = "x" ] ; do
	zenity --title="Error" --error --text="Please try again."
done

while ! useradd -c "$name,,," -G adm,audio,video,netdev,wheel,plugdev "$username" ; do
	username=$(zenity --title="Please check username" --entry --text "Please be sure that your
username consists of only
letters and numbers." --entry-text "$username")
done

# Password setup.

password=""
while [ x$password = x ] ; do
	password1=$(zenity --title=Password --entry --text="Choose a new password." --hide-text)
	password2=$(zenity --title=Confirm --entry --text="Confirm your new password." --hide-text)
	if [ $password1 != $password2 ] ; then 
		zenity --title="Error" --error --text="Passwords don't match.
Please try again."
	else if [ x$password1 = x ] ; then
		zenity --title="Error" --error --text="Password can not be blank!
Please try again."
		else
			password=$password1
		fi
	fi
done

passwd "$username" <<EOF
$password
$password
EOF

# Name our little baby

while ! hostname=$(zenity --title="Name your Pandora" --entry --text "Please choose a name for
your Pandora. It should only contain
letters, numbers and dashes." --entry-text "$username-pandora") || [ "x$hostname" = "x" ]; do 
	zenity --title="Error" --error --text="Please try again."
done

echo $hostname > /etc/hostname
echo "127.0.0.1 localhost.localdomain localhost $hostname" > /etc/hosts
#cat /usr/share/first-boot-wizard/hosts-template >> /etc/hosts
hostname -F /etc/hostname


# Set the correct user for Autologin and enable / disable it.

if zenity --question --title="Autologin" --text="Do you want to automatically login on startup?\n\nSecurity warning: This skips the password check on startup" --ok-label="Yes, enable Autologin" --cancel-label="Do not enable Autologin"; then      	
     # echo "PREFERED_USER=$username" > /etc/default/autologin
      sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
      sed -i 's/.*auto_login.*/auto_login yes/g' /etc/slim.conf
      else
      sed -i 's/.*auto_login.*/auto_login no/g' /etc/slim.conf
fi

# Setup which GUI will run as default. At the moment, it just creates a small file and puts Xfce or PMenu into it :)

if zenity --question --title="Default Inteface" --text="Now you can choose whether you want to boot into a full desktop interface or a gaming console-like launcher by default.\n\nYou can always change this setting later." --ok-label="Full Desktop (Xfce)"  --cancel-label="Gaming 
console-like Launcher"; then 
	echo Xfce > /etc/bootup.cfg
	else
	echo PMenu > /etc/bootup.cfg
fi

zenity --info --title="Finished" --text "This concludes the First Boot Wizard.\nThanks for buying the OpenPandora. Enjoy the device!"
