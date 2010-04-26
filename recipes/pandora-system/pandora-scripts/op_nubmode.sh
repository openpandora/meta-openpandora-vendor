#!/bin/bash

while mainsel=$(zenity --title="Nub-Configuration" --width="430" --height="400" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "nub0mode" "Change the mode for the left nub" "nub0msense" "Change the mouse speed for the left nub" "nub0ssense" "Change the scroll sensitivity for the left nub" "nub0rate" "Change the scroll speed for the left nub" "nub0thres" "Change the mouse button sensitivity for the left nub" "nub1mode" "Change the mode for the right nub" "nub1msense" "Change the mouse speed for the right nub" "nub1ssense" "Change the scroll sensitivity for the right nub" "nub1rate" "Change the scroll speed for the right nub" "nub1thres" "Change the mouse button sensitivity for the right nub" "default" "Restore default settings for both nubs"); do

case $mainsel in

  "nub0mode")
      if nubm=$(zenity --height=300 --list --title="Select Nub-mode for the left nub" --text="Please select the modus for the left nub.\n\nNote: This can affect running programs.\nSome programs also may change the nub mode themselves."  --column "return" --hide-column=1 --column "Nub Mode" "mouse" "Use the nub as mouse" "mbuttons" "Use the nub for mousebuttons" "scroll" "Use the nub for scrolling" "absolute" "Use the nub as joystick") ; then

      echo $nubm > /proc/pandora/nub0/mode
      fi;;

  "nub0msense")
      curmsense=$(cat /proc/pandora/nub0/mouse_sensitivity)
      newmsense=$(zenity --scale --text "Set speed for left nub mouse.\nThe default value is 150. Higher value means faster mouse." --min-value=50 --max-value=300 --value=$curmsense --step 1)
      echo $newmsense > /proc/pandora/nub0/mouse_sensitivity
      ;;
    
  "nub0ssense")
      curssense=$(cat /proc/pandora/nub0/scrollx_sensitivity)
      newssense=$(zenity --scale --text "Set the scroll sensitivity for the left nub for the X-Axis.\nThe default value is 7. Higher value means more sensitive.\nA negative value inverts the axis." --min-value=-32 --max-value=32 --value=$curssense --step 1)
      echo $newssense > /proc/pandora/nub0/scrollx_sensitivity
      curssense=$(cat /proc/pandora/nub0/scrolly_sensitivity)
      newssense=$(zenity --scale --text "Set the scroll sensitivity for the left nub for the Y-Axis.\nThe default value is 7. Higher value means more sensitive.\nA negative value inverts the axis." --min-value=-32 --max-value=32 --value=$curssense --step 1)
      echo $newssense > /proc/pandora/nub0/scrolly_sensitivity
      ;;

  "nub0rate")
      currate=$(cat /proc/pandora/nub0/scroll_rate)
      newrate=$(zenity --scale --text "Set the scroll speed for the left nub.\nThe default value is 20. Higher value means more sensitive." --min-value=1 --max-value=40 --value=$currate --step 1)
      echo $newrate > /proc/pandora/nub0/scroll_rate
      ;;
     
  "nub0thres")
      curthres=$(cat /proc/pandora/nub0/mbutton_threshold)
      newthres=$(zenity --scale --text "Change the mousebutton sensitivity for the left nub.\nThe default value is 20.\nThe higher the value the higher you need to move the nub" --min-value=1 --max-value=40 --value=$curthres --step 1)
      echo $newthres > /proc/pandora/nub0/mbutton_threshold
      ;;

  "nub1mode")
      if nubm=$(zenity --height=300 --list --title="Select Nub-mode for the right nub" --text="Please select the modus for the right nub.\n\nNote: This can affect running programs.\nSome programs also may change the nub mode themselves."  --column "return" --hide-column=1 --column "Nub Mode" "mouse" "Use the nub as mouse" "mbuttons" "Use the nub for mousebuttons" "scroll" "Use the nub for scrolling" "absolute" "Use the nub as joystick") ; then

      echo $nubm > /proc/pandora/nub1/mode
      fi;;

  "nub1msense")
      curmsense=$(cat /proc/pandora/nub1/mouse_sensitivity)
      newmsense=$(zenity --scale --text "Set speed for right nub mouse.\nThe default value is 150. Higher value means faster mouse." --min-value=50 --max-value=300 --value=$curmsense --step 1)
      echo $newmsense > /proc/pandora/nub1/mouse_sensitivity
      ;;
    
  "nub1ssense")
       curssense=$(cat /proc/pandora/nub1/scrollx_sensitivity)
      newssense=$(zenity --scale --text "Set the scroll sensitivity for the right nub for the X-Axis.\nThe default value is 7. Higher value means more sensitive.\nA negative value inverts the axis." --min-value=-32 --max-value=32 --value=$curssense --step 1)
      echo $newssense > /proc/pandora/nub1/scrollx_sensitivity
      curssense=$(cat /proc/pandora/nub1/scrolly_sensitivity)
      newssense=$(zenity --scale --text "Set the scroll sensitivity for the right nub for the Y-Axis.\nThe default value is 7. Higher value means more sensitive.\nA negative value inverts the axis." --min-value=-32 --max-value=32 --value=$curssense --step 1)
      echo $newssense > /proc/pandora/nub1/scrolly_sensitivity
      ;;

  "nub1rate")
      currate=$(cat /proc/pandora/nub1/scroll_rate)
      newrate=$(zenity --scale --text "Set the scroll speed for the right nub.\nThe default value is 20. Higher value means more sensitive." --min-value=1 --max-value=40 --value=$currate --step 1)
      echo $newrate > /proc/pandora/nub1/scroll_rate
      ;;
     
  "nub1thres")
      curthres=$(cat /proc/pandora/nub1/mbutton_threshold)
      newthres=$(zenity --scale --text "Change the mousebutton sensitivity for the right nub.\nThe default value is 20.\nThe higher the value the higher you need to move the nub" --min-value=1 --max-value=40 --value=$curthres --step 1)
      echo $newthres > /proc/pandora/nub1/mbutton_threshold
      ;;
  "default")
      echo mouse > /proc/pandora/nub0/mode
      echo 150 > /proc/pandora/nub0/mouse_sensitivity
      echo 7 > /proc/pandora/nub0/scrollx_sensitivity
      echo 7 > /proc/pandora/nub0/scrolly_sensitivity
      echo 20 > /proc/pandora/nub0/scroll_rate
      echo 20 > /proc/pandora/nub0/mbutton_threshold
      echo mbuttons > /proc/pandora/nub1/mode
      echo 150 > /proc/pandora/nub1/mouse_sensitivity
      echo 7 > /proc/pandora/nub1/scrollx_sensitivity
      echo 7 > /proc/pandora/nub1/scrolly_sensitivity
      echo 20 > /proc/pandora/nub1/scroll_rate
      echo 20 > /proc/pandora/nub1/mbutton_threshold
      zenity --info --title="Settings restored" --text "The default nub-settings have been restored." --timeout 6
    ;;
esac
done