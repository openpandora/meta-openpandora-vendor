#!/bin/bash

selection=$(cat /etc/pandora/conf/gui.conf | awk -F\; '{print $1 "\n" $2 }' | zenity --width=500 --height=300 --title="Switch to a different GUI" --list --column "name" --column "description" --text "Select a GUI you want to switch to" )
echo $selection

gui=$(grep $selection /etc/pandora/conf/gui.conf | awk -F\; '{print $3}')
stopnew=$(grep $selection /etc/pandora/conf/gui.conf | awk -F\; '{print $4}')

echo $gui

if [ $gui ]; then 
  echo "$gui" > /tmp/gui.load
  echo "$stopnew" > /tmp/gui.stopnew
  echo $selection will be started
  /tmp/gui.stop
else
  exit 0
fi