#!/bin/bash

user=$(cat /tmp/currentuser)

# change what to do when the lid is closed/opened
case "$(cat /home/$user/.lidconfig)" in
	"lowpower")
		current="the Pandora goes into low power mode"
	;;
	"shutdown")
		current="the Pandora is shut down"	
	;;
	*)
		current="the screen is turned off"
	;;
esac

sel=$(zenity --title="Lid settings" --height=250 --list --column "id" --column "Please select" --hide-column=1 --text="What should happen when you close the Pandora's lid?\n(the opposite of the selected action is performed when opening the lid again)\nAt the moment $current when you close the lid." "brightness" "Turn off the screen." "lowpower" "Go into low power mode (same as when pressing the
power button for less than 3 seconds)" "shutdown" "Shut the pandora down.") || exit
echo "$sel" > /home/$user/.lidconfig
