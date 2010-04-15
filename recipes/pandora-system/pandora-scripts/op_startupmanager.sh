#!/bin/bash

selection=$(cat /etc/pandora/conf/gui.conf | awk -F\; '{print $1 "\n" $2 }' | zenity ---width=500 --height=300 --title="Change he Default GUI" --list --column "Name" --column "Description" --text "Please select the GUI you want to run as default startup" )
echo $selection

gui=$(grep $selection /etc/pandora/conf/gui.conf | awk -F\; '{print $3}')

echo $gui

if [ $gui ]; then 
  sed -i "s/.*DEFAULT_SESSION=.*/DEFAULT_SESSION=$gui/g" ~/.xinitrc
  echo $selection selected as default interface
  zenity --info --title="Changed session" --text "Thank you, the default session has been changed to $selection." --timeout 6
else
  exit 0
fi