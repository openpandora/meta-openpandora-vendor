#!/bin/bash
# These are just some very basic TV-Out scripts. The picture will most likely not properly be centered, etc. An enhanced one is currently being scripted. 

while mainsel=$(zenity --title="TV-Out Configuration" --width="380" --height="200" --list --column "id" --column "Please select" --hide-column=1 --text="This is a very simple TV Out Script. It will be enhanced." "pal" "Enable TV Out in PAL Mode" "ntsc" "Enable TV Out in NTSC Mode" "disable" "Disable TV Out"); do

case $mainsel in
  "pal")
  cd /sys/devices/platform/omapdss
  echo 0 > overlay0/enabled
  echo 0 > overlay2/enabled
  echo 0 > overlay1/enabled
  echo 0 > display1/enabled
  echo "" > /sys/class/graphics/fb2/overlays
  echo "0,2" > /sys/class/graphics/fb0/overlays
  echo "658,520" > overlay2/output_size
  echo "tv" > overlay2/manager
  echo "35,35" > overlay2/position 
  echo "pal" > display1/timings
  echo 1 > overlay0/enabled
  echo 1 > overlay2/enabled
  echo 1 > display1/enabled
  zenity --info --title="TV Out" --text "TV Out (PAL Mode) has been enabled." --timeout 6
  ;;

  "ntsc")
  cd /sys/devices/platform/omapdss
  echo 0 > overlay0/enabled
  echo 0 > overlay2/enabled
  echo 0 > overlay1/enabled
  echo 0 > display1/enabled
  echo "" > /sys/class/graphics/fb2/overlays
  echo "0,2" > /sys/class/graphics/fb0/overlays
  echo "658,520" > overlay2/output_size
  echo "tv" > overlay2/manager
  echo "35,35" > overlay2/position 
  echo "ntsc" > display1/timings
  echo 1 > overlay0/enabled
  echo 1 > overlay2/enabled
  echo 1 > display1/enabled   
  zenity --info --title="TV Out" --text "TV Out (NTSC Mode) has been enabled." --timeout 6  
  ;;

  "disable")
  cd /sys/devices/platform/omapdss
  echo 0 > overlay0/enabled
  echo 0 > overlay2/enabled
  echo 0 > overlay1/enabled
  echo 0 > display1/enabled
  echo "" > /sys/class/graphics/fb2/overlays
  echo "0" > /sys/class/graphics/fb0/overlays
  echo 1 > overlay0/enabled
  zenity --info --title="TV Out" --text "TV Out has been disabled." --timeout 6
  ;;    
  esac
done
