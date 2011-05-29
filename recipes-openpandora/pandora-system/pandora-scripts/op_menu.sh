#!/bin/bash
#actions done when the menu button is pressed
#only argument is the time the button was pressed in  seconds

if [ "$1" -ge "2" ]; then #button was pressed 3 sec or longer, show list of apps to kill instead of launcher
  killist=y
fi

xpid=$(pidof xfce4-session)
if [ $xpid ]; then
  echo "xfce4 is running"
  # note: max username length ps can output is 19, otherwise it prints uid
  xfceuser=$(ps -o user:20= -C xfce4-session | tail -n1 | awk '{print $1}')
  if [ $killist ]; then
    echo "displaying kill list"
    pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*-\(.*\)(\([0-9]\+\))/\2\n \1/p' | su -c 'DISPLAY=:0.0 zenity --list --multiple --column "pid" --column "name" --title "kill" --text "which apps should be killed"' - $xfceuser | sed 's/|/\n/')
    for PID in $pidlist
    do
      kill -9 $PID
    done
  else
    # echo "starting appfinder"
    # invoke the appfinder; nice app, but it takes a few seconds to come up
    #su -c 'DISPLAY=:0.0 xfce4-appfinder' - $xfceuser
    # invoke the bottom-left popup menu, for launching new apps, instead.
    popuppid=$(pidof xfce4-popup-menu)
    if [ $popuppid ]; then
	echo "popup menu is already running"
    else
	su -c 'DISPLAY=:0.0 xfce4-popup-menu' - $xfceuser
    fi
  fi
else
  echo "no x, killing all pnd aps so x or DE gets restarted"
  pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
  for PID in $pidlist
  do
    kill -9 $PID
  done
fi
