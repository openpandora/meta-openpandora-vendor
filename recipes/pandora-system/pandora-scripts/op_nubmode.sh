#!/bin/bash
# Released under the GPL
# Nub-Settings, v1.1, written by Michael Mrozek aka EvilDragon 2010
# This scripts allows you to configure all parameters of the Pandora-Nubs. The left and right nub can both be configured individually.

while mainsel=$(zenity --title="Nub-Configuration" --width="380" --height="200" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "leftnub" "Configure left nub" "rightnub" "Configure right nub" "default" "Restore default settings for both nubs"); do

case $mainsel in
  "leftnub")

   while leftsel=$(zenity --title="Configure Left Nub" --width="430" --height="300" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "nub0mode" "Change Nub mode" "nub0msense" "Change the mouse speed" "nub0ssense" "Change the scroll sensitivity" "nub0rate" "Change the scroll speed" "nub0thres" "Change the mouse button sensitivity" "nub0reset" "Reset Nub"); do
   case $leftsel in

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
 
    "nub0reset")
        echo 1 > /sys/bus/i2c/drivers/vsense/3-0066/reset
        sleep 1
        echo 0 > /sys/bus/i2c/drivers/vsense/3-0066/reset
        curmode=$(cat /proc/pandora/nub0/mode)
        echo mouse > /proc/pandora/nub0/mode
        while ! zenity --question --title="Resetted left nub" --text="The left nub has been resetted.\nPlease try to move the mouse cursor\nto test if it is working properly." --ok-label="Working properly" --cancel-label="Reset again"; do
        echo 1 > /sys/bus/i2c/drivers/vsense/3-0066/reset
        sleep 1
        echo 0 > /sys/bus/i2c/drivers/vsense/3-0066/reset      
        done
        echo curmode > /proc/pandora/nub0/mode
        ;;
     esac
   done
  ;;
  
  "rightnub")
  
   while rightsel=$(zenity --title="Configure Right Nub" --width="430" --height="300" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "nub1mode" "Change Nub mode" "nub1msense" "Change the mouse speed" "nub1ssense" "Change the scroll sensitivity" "nub1rate" "Change the scroll speed" "nub1thres" "Change the mouse button sensitivity" "nub1reset" "Reset Nub"); do
   case $rightsel in
  
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

    "nub1reset")
        echo 1 > /sys/bus/i2c/drivers/vsense/3-0067/reset
        sleep 1
        echo 0 > /sys/bus/i2c/drivers/vsense/3-0067/reset
        curmode=$(cat /proc/pandora/nub1/mode)
        echo mouse > /proc/pandora/nub1/mode
        while ! zenity --question --title="Resetted right nub" --text="The right nub has been resetted.\nPlease try to move the mouse cursor\nto test if it is working properly." --ok-label="Working properly" --cancel-label="Reset again"; do
        echo 1 > /sys/bus/i2c/drivers/vsense/3-0067/reset
        sleep 1
        echo 0 > /sys/bus/i2c/drivers/vsense/3-0067/reset      
        done
        echo curmode > /proc/pandora/nub1/mode
        ;;
     esac
   done
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