#!/bin/sh
launcher=$(zenity --height 240 --list --title="Switch to a different GUI" --text="Please select the GUI you want to switch to.\nNote: All running applications will be terminated!" --column "return" --print-column=1 --hide-column=1 --column "Pick a launcher" "startxfce4" "Switch to Xfce" "startmmenu" "Switch to MiniMenu" "pmenu" "Switch to PMenu" "startnetbooklauncher" "Switch to Netbook Launcher")

if [ "$launcher" == "" ]; then 
    exit 0
else
    echo "$launcher" > /tmp/gui.load
    if [ "$(pidof xfce4-session)" ] 
      then
	xfce4-session-logout --logout
      else
	killall netbook-launcher-efl
     fi
fi
