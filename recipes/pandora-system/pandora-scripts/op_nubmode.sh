#!/bin/bash

if nubl=$(zenity --height=250 --list --title="Select Nub-mode for the left nub" --text="Please select the modus for the left nub.\n\nNote: This can affect running programs.\nSome programs also may change the nub mode themselves."  --column "return" --hide-column=1 --column "Nub Mode" "mouse" "Use the nub as mouse" "scroll" "Use the nub for scrolling" "absolute" "Use the nub as joystick" "mbuttons" "Use the nub as mouse buttons (not implemented yet)") ; then

echo $nubl > /proc/pandora/vsense66

fi

if nubr=$(zenity --height=250 --list --title="Select Nub-mode for the right nub" --text="Please select the modus for the right nub.\n\nNote: This can affect running programs.\nSome programs also may change the nub mode themselves."  --column "return" --hide-column=1 --column "Nub Mode" "mouse" "Use the nub as mouse" "scroll" "Use the nub for scrolling" "absolute" "Use the nub as joystick" "mbuttons" "Use the nub as mouse buttons (not implemented yet)") ; then

echo $nubr > /proc/pandora/vsense67

fi