#!/bin/sh

# Initially based on the scripts by JohnX/Mer Project - http://wiki.maemo.org/Mer/
# Reworked for the OpenPandora - John Willis/Michael Mrozek

# You can start the wizard from the shell using 'xinit ./first-boot-init.sh'

export LANG=en_GB.UTF-8
export GTK2_RC_FILES=/usr/share/themes/Xfce/gtk-2.0/gtkrc
xmodmap /etc/skel/.pndXmodmap

# Ensure there is a wheel group for sudoers to be put into.
# TODO: Do this somewhere better.
groupadd wheel

# We load up a background image here.
export WALLPAPER='/usr/share/xfce4/backdrops/op-firstrun.png'
hsetroot -center $WALLPAPER

# Default error message (should a user hit cancel, validation fail etc.).
ERROR_WINDOW='zenity --title="Error" --error --text="Sorry! Please try again." --timeout 6'

RESET_ROOT="no"

xset s off
xset -dpms

#Stop WiFi
rmmod board_omap3pandora_wifi wl1251_sdio wl1251

# Greet the user.

if zenity --question --title="Pandoras Box has been opened." --text="Welcome!\n\nPandora's Box has been opened.\n\nThis wizard will help you setting up your new OpenPandora handheld before the first use.\n\nYou will be asked a few simple questions to personalise and configure your device.\n\nDo you want to set up your unit now or shut the unit down and do it later?" --ok-label="Start now" --cancel-label="Shutdown" ; then
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

while ! useradd -c "$name,,," -G adm,audio,cdrom,netdev,plugdev,users,video,wheel "$username" ; do
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

while ! hostname=$(zenity --title="Name your Pandora" --entry --text "Please choose a name for your OpenPandora.\n\nIt should only contain letters, numbers and dashes, no spaces." --entry-text "$username-openpandora") || [ "x$hostname" = "x" ]; do 
	zenity --title="Error" --error --text="Please try again."
done


echo $hostname > /etc/hostname
hostname =$(sed 's/ /_/g' /etc/hostname)
echo $hostname > /etc/hostname
echo "127.0.0.1 localhost.localdomain localhost $hostname" > /etc/hosts
hostname -F /etc/hostname

# Set the correct user for Autologin and enable / disable it.

if zenity --question --title="Autologin" --text="If you like, you can setup your Pandora to autologin into the system at startup.\nWhile this is more convenient for most users, it features a potential security issue, as no password will be needed to access your desktop and personal files.\n\nDo you wish to automatically login at startup?" --ok-label="Yes" --cancel-label="No"; then      	
	# echo "PREFERED_USER=$username" > /etc/default/autologin
	sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
	sed -i 's/.*auto_login.*/auto_login yes/g' /etc/slim.conf
else
	if zenity --question --title="User" --text="Do you wish to have your username automatically populated in the login screen?\n\nNote: This is ideal if you're the only user of the OpenPandora but wish to disable autologin and use a password." --ok-label="Yes" --cancel-label="No"; then 
		sed -i "s/.*default_user.*/default_user $username/g" /etc/slim.conf
		sed -i 's/.*auto_login.*/auto_login no/g' /etc/slim.conf
	else
		sed -i "s/.*default_user.*/default_user/g" /etc/slim.conf
		sed -i 's/.*auto_login.*/auto_login no/g' /etc/slim.conf
	fi
fi

# ----

# Select the default interface and setup SLiM to pass that as a sesion to ~./.xinitrc

selection=""
while [ x$selection = x ]; do
selection=$(cat /etc/pandora/conf/gui.conf | awk -F\; '{print $1 "\n" $2 }' | zenity --width=500 --height=310 --title="Select the Default GUI" --list --column "Name" --column "Description" --text "You can now select your preferred GUI - the GUI that will be loaded automatically on startup of the unit.\n\nYou can either select XFCE4, which is a full desktop environment (similar to a normal PC).\nOr you could select MiniMenu, which is a minimal UI similar to gaming devices.\n\nIf you select the last choice (GUISwitch), you will be prompted to choose a GUI each time you boot your Pandora.\n\nThis setting can always be changed later by running the Startup-Settings." )
if [ x$selection = x ]; then
  zenity --title="Error" --error --text="Please select a GUI." --timeout=6
fi
done

echo $selection

gui=$(grep $selection /etc/pandora/conf/gui.conf | awk -F\; '{print $3}')
stopcommand=$(grep $selection /etc/pandora/conf/gui.conf | awk -F\; '{print $4}')

echo $gui

  sed -i "s/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=\"$gui\"/g" /home/$username/.xinitrc
  echo $selection selected as default interface
  zenity --info --title="Selected session" --text "You selected $selection as default setting." --timeout 6

# ----

# Set the timezone and date/time

while ! area=$(zenity --list --title "Select your time zone" --text="Please select your area" --column="Select your area" --print-column=1 "Africa" "America" "Asia" "Australia" "Europe" "Pacific" --width=500 --height=260) || [ "x$area" = "x" ] ; do
	zenity --title="Error" --error --text="Please select your area." --timeout=6
done

while ! timezone=$(ls -1 /usr/share/zoneinfo/$area | zenity ---width=500 --height=200 --title="Select your closest location" --list --column "Closest Location" --text "Please select the location closest to you") || [ "x$timezone" = "x" ] ; do
	zenity --title="Error" --error --text="Please select your location." --timeout=6
done

echo $timezone
rm /etc/localtime && ln -s /usr/share/zoneinfo/$area/$timezone /etc/localtime

#Make sure we clean up any leading zeros in the day (as Zenity freaks out)
date_d=`date +%d | sed 's/^0//'`
date_m=`date +%m | sed 's/^0//'`
date_y=`date +%Y`

while ! date=$(zenity --calendar --text="Please select the current date" --title "Please select the current date" --day=$date_d --month=$date_m --year=$date_y --date-format="%Y%m%d" --width=500) || [ "x$date" = "x" ] ; do
        zenity --title="Error" --error --text="Please select the date." --timeout 6
done

echo $date

time_h=`date +%H`
time_m=`date +%M`

while ! time=$(zenity --title="Enter current time" --entry --text "Please enter the time in 24hour format (HH:MM).\n" --entry-text "$time_h:$time_m") || [ "x$time" = "x" ] ; do
        zenity --title="Error" --error --text="Please input the time." --timeout 6
done

while ! date -d $time ; do
	time=$(zenity --title="Enter current time" --entry --text "Please enter the time in 24hour format (HH:MM).\n" --entry-text "$time_h:$time_m")
done
 
date +%Y%m%d -s $date
date +%H:%M -s $time
hwclock -u -w


#Let's ask the user about clockspeed
while ! cpusel=$(zenity --title="Optional settings" --width="400" --height="350" --list --column "id" --column "Please select" --hide-column=1 --text="The CPU of the Pandora supports different speed settings.\nHigher speeds might make some units unstable and decrease the lifetime of your CPU.\n\nBelow are some quick profiles which will help you to configure your system the way you like it.\n" "1100" "Clockspeed: 1,1Ghz, OPP5 (should be stable on 1GHz units)" "1000" "Clockspeed: 1GHz, OPP5 (most probably unstable on 600Mhz units)" "800" "Clockspeed: 800MHz, OPP5 (should be stable on all units)" "600" "Clockspeed: 600MHz, OPP3 (600 MHz units only)" --ok-label="Select CPU Profile" ); do
    zenity --title="Error" --error --text="Please select your desired CPU Speed profile." --timeout=6
done

case $cpusel in
  "1100")
  echo 5 > /proc/pandora/cpu_opp_max
  sed -i "s/.*maxopp.*/maxopp:5/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*max:.*/max:1200/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*default.*/default:1100/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*safe.*/safe:1100/g" /etc/pandora/conf/cpu.conf
  default_cpu=1100
  ;;

  "1000")
  echo 5 > /proc/pandora/cpu_opp_max
  sed -i "s/.*maxopp.*/maxopp:5/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*max:.*/max:1100/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*default.*/default:1000/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*safe.*/safe:1000/g" /etc/pandora/conf/cpu.conf
  default_cpu=1000
  ;;

  "800")
  echo 5 > /proc/pandora/cpu_opp_max
  sed -i "s/.*maxopp.*/maxopp:5/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*max:.*/max:900/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*default.*/default:800/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*safe.*/safe:800/g" /etc/pandora/conf/cpu.conf
  default_cpu=800
  ;;



  "600")
  echo 3 > /proc/pandora/cpu_opp_max
  sed -i "s/.*maxopp.*/maxopp:3/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*max:.*/max:700/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*default.*/default:600/g" /etc/pandora/conf/cpu.conf
  sed -i "s/.*safe.*/safe:600/g" /etc/pandora/conf/cpu.conf
  default_cpu=600
  ;;

esac

# ----

# NOTE: This is just a temporary fix! These daemons should be removed from startup in the OE recipes. Until the time is found, we'll do it from here.
update-rc.d -f samba remove
update-rc.d -f xinetd remove
update-rc.d -f avahi-daemon remove
update-rc.d -f apmd remove
update-rc.d -f usb-gadget remove
update-rc.d -f banner remove
update-rc.d -f portmap remove
update-rc.d -f mountnfs remove
update-rc.d -f blueprobe remove
update-rc.d -f dropbear remove
update-rc.d -f wl1251-init remove

# prevent wifi from being autoloaded on later kernels, let wl1251-init script do it
if ! grep -q 'blacklist wl1251_sdio' /etc/modprobe.conf 2> /dev/null; then
  echo 'blacklist wl1251_sdio' >> /etc/modprobe.conf
fi
# we don't ship firmware for rtl8192cu, and it was reported not to work
# with the right firmware anyway (not verified though)
# vendor 8192cu is compiled instead for now
if ! grep -q 'blacklist rtl8192cu' /etc/modprobe.conf 2> /dev/null; then
  echo 'blacklist rtl8192cu' >> /etc/modprobe.conf
fi

# add Midi Module and zram
echo snd-seq>>/etc/modules
echo zram>>/etc/modules

# get rid of some dirs in /media that OE creates but are unlikely to be used
rmdir /media/card /media/cf /media/mmc1 /media/net /media/realroot /media/union 2> /dev/null

# Write the control file so this script is not run on next boot 
# (hackish I know but I want the flexability to drop a new script in later esp. in the early firmwares).

touch /etc/pandora/first-boot
# Make the control file writeable by all to allow the user to delete to rerun the wizard on next boot.
chmod 0666 /etc/pandora/first-boot

if zenity --question --title="Calibrate Touchscreen" --text="It is recommended to calibrate the touchscreen to make sure it accurately works.\n\nIf you do so, you will see a moving crosshair.\nUse the stylus to press the crosshair as accurate as possible.\n\nYou can always (re-)calibrate it from the Settings-Menu later in the OS as well." --ok-label="Calibrate Touchscreen" --cancel-label="Don't calibrate it"; then
  . /etc/profile
  TSLIB_CONSOLEDEVICE=none op_runfbapp ts_calibrate
  /usr/pandora/scripts/op_touchinit.sh
while ! zenity --question --title="Check Calibration" --text="Your new calibration setting has been applied.\n\nPlease check if the touchscreen is now working properly.\nIf not, you might want to try a recalibration.\n\n(Hint: use the nubs to press the button if the touchscreen is way off)" --ok-label="The touchscreen is fine" --cancel-label="Recalibrate"; do
      TSLIB_CONSOLEDEVICE=none op_runfbapp ts_calibrate
  /usr/pandora/scripts/op_touchinit.sh  
done
fi



# Let the user run optional config stuff.

while mainsel=$(zenity --title="Optional settings" --width="400" --height="300" --list --column "id" --column "Please select" --hide-column=1 --text="This concludes the mandatory part of the First Boot Wizard.\n\nYou can now either continue to boot the system or change some more settings.\n\n\nThank you for buying the OpenPandora. Enjoy using the device." "speed" "Advanced CPU-Speed and Overclocking-Settings" "startup" "Advanced Startup-Settings" "lcd" "LCD-Settings" --ok-label="Change selected Setting" --cancel-label="Finish Setup"); do

case $mainsel in
  "speed")
  /usr/pandora/scripts/op_cpusettings.sh
  ;;

   "startup")
  echo $username > /tmp/currentuser
  /usr/pandora/scripts/op_startupmanager.sh
  ;;

   "lcd")
  /usr/pandora/scripts/op_lcdsettings.sh
  ;;

esac
done
systemctl reboot
# ----


# ----
else
poweroff
fi
