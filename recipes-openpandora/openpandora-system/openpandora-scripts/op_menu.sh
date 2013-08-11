#!/bin/bash
#actions done when the menu button is pressed
#only argument is the time the button was pressed in  seconds

user=$(cat /tmp/currentuser)

# show list of apps to kill if Pandora button held down for 2 secs or longer
if [ "$1" != "" ]; then
	if [ "$1" -ge "2" ]; then
		pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*-\(.*\)(\([0-9]\+\))/\2\n \1/p' | su -c 'DISPLAY=:0.0 zenity --list --multiple --column "pid" --column "name" --title "kill" --text "which apps should be killed"' - $user)
		for PID in $pidlist
		do
			kill -9 $PID
		done
	fi
fi

# Show menu (XFCE / Openbox) or kill current PND (MiniMenu) if Pandora key just pressed once

# XFCE 4.10
xpid=$(pidof xfce4-session)
if [ $xpid ]; then
	su -c "export DISPLAY=:0.0; export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$xpid/environ | cut -d= -f2-); /usr/bin/xfce4-panel --plugin-event=applicationsmenu:popup:bool:false || xdotool key Escape" $user	

# Openbox
elif [ $(pidof openbox) ]; then
	su -c 'DISPLAY=:0.0 xdotool mousemove 50 50; DISPLAY=:0.0 xdotool key ctrl+XF86MenuKB' - $user

# MiniMenu
else
	pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
	for PID in $pidlist
	do
		kill -9 $PID
	done
fi
