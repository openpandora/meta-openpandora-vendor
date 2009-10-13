#!/bin/sh

# notice: system dbus must be running

export LANG=en_GB.UTF-8
# for testing set display to something sane
if [ "x$DISPLAY" = "x" ]; then
	export DISPLAY=:0
fi
export MB_HUNG_APP_HANDLER='/usr/bin/hd-hung-app-handler'
export GTK2_RC_FILES=/usr/share/themes/default/gtk-2.0/gtkrc:/usr/share/themes/default/gtk-2.0/gtkrc.maemo_af_desktop

WALLPAPER=`grep File= /usr/share/backgrounds/default.desktop | cut -d"=" -f2`
hsetroot -center $WALLPAPER

export `dbus-launch --exit-with-session`

#/usr/bin/maemo-launcher --daemon --booster gtk

/usr/lib/gconf2/gconfd-2 &
#/usr/lib/libgconf2-4/gconfd-2 &

#/usr/lib/sapwood/sapwood-server &

SHOW_CURSOR=yes

#/usr/bin/matchbox-window-manager \
#      -theme default \
#      -use_titlebar yes \
#      -use_desktop_mode plain \
#      -use_lowlight no \
#      -use_cursor $SHOW_CURSOR \
#      -use_super_modal no &

/usr/bin/x-window-manager

#maemo-invoker /usr/bin/hildon-input-method.launch &

#if /usr/bin/lshal | grep info.product | grep -i keyboard ; then
#	/usr/bin/gconftool-2 -s -t bool /apps/osso/inputmethod/keyboard_available true 
#fi


##First we regenerate existing ssh keys:
#rm -f /etc/ssh/ssh_host*
#/usr/bin/ssh-keygen -t dsa -q -N "" -f /etc/ssh/ssh_host_dsa_key | \
#	zenity --title="Please wait..." --text="Generating SSH DSA key." \
#	--progress --pulsate --auto-close
#/usr/bin/ssh-keygen -t rsa -q -N "" -f /etc/ssh/ssh_host_rsa_key |
#	zenity --title="Please wait..." --text="Generating SSH RSA key." \
#	--progress --pulsate --auto-close


swap_part=$(sfdisk -l /dev/mmcblk? | grep swap | cut -d" " -f1)
if [ x$swap_part != x ] ; then
	use_swap=$(zenity --title="Enable swap?" --text "Swap partition found. Would you like to use it?" --list --radiolist --column " " --column "Answer" TRUE "Use swap on $swap_part" FALSE "Do not use swap")
	if [ "$use_swap" = "Use swap on $swap_part" ] ; then
		swapon $swap_part
        	echo "$swap_part none swap sw 0 0" >> /etc/fstab
	fi
fi

while ! name=$(zenity --title="Type your name" --entry --text "Please type your full name.") || [ "x$name" = "x" ] ; do
	zenity --title="Error" --error --text="Please try again."
done

username_guess=$(echo "$name" | cut -d" " -f1 | tr A-Z a-z)

while ! username=$(zenity --title="Type your username" --entry --text "Please choose a short username.
It should be all lowercase and
contain only letters and numbers." --entry-text "$username_guess") || [ "x$username" = "x" ] ; do
	zenity --title="Error" --error --text="Please try again."
done

while ! adduser --gecos "$name,,," --disabled-password "$username" ; do
	username=$(zenity --title="Please check username" --entry --text "Please be sure that your
username consists of only
letters and numbers." --entry-text "$username")
done

password=""
while [ x$password = x ] ; do
	password1=$(zenity --title=Password --entry --text="Choose a new password." --hide-text)
	password2=$(zenity --title=Confirm --entry --text="Confirm your new password." --hide-text)
	if [ $password1 != $password2 ] ; then 
		zenity --title="Error" --error --text="Passwords don't match.
Please try again."
	else if [ x$password1 = x ] ; then
		zenity --title="Error" --error --text="Password can't be blank!
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

for group in users admin adm audio video netdev plugdev ; do 
	if ! grep ^$group: /etc/group ; then
		addgroup --system "$group"
	fi
	adduser "$username" "$group" ; done
echo "PREFERED_USER=$username" > /etc/default/autologin

mkdir -p /etc/sudoers.d && echo '# Members of the admin group may gain root privileges' > /etc/sudoers.d/02ubuntu-admin
echo '%admin ALL=(ALL) ALL' >> /etc/sudoers.d/02ubuntu-admin
update-sudoers
while ! hostname=$(zenity --title="Choose a device name" --entry --text "Please choose a name for
your OpenPandora. It should only contain
letters, numbers and dashes." --entry-text "$username-pandora") || [ "x$hostname" = "x" ]; do 
	zenity --title="Error" --error --text="Please try again."
done

echo $hostname > /etc/hostname
echo "127.0.0.1 localhost.localdomain localhost $hostname" > /etc/hosts
cat /usr/share/first-boot-wizard/hosts-template >> /etc/hosts
hostname -F /etc/hostname

killall maemo-launcher
killall gconfd-2
