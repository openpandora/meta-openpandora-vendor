#!/bin/bash
#get value range
minmhz=14
safemhz=600
maxmhz=900
curmhz="$(cat /proc/pandora/cpu_mhz_max)"
newmhz="$(cat /proc/pandora/cpu_mhz_max)"
device=/proc/pandora/cpu_mhz_max
if [ ! $1 ]; then
	if [ $DISPLAY ]; then
		newmhz=$(zenity --scale --text "Set CPU clockspeed" --min-value=$minmhz --max-value=$maxmhz --value=$curmhz --step 1)
	else
		newmhz=$(read -p "Please enter the desired clockspeed")
	fi
else
newmhz=$1
fi
if [ $newmhz ]; then
        if [ $newmhz -ge $safemhz ]; then
                if [ $DISPLAY ]; then
                        answer=$(zenity --question --title "Alert" --text "You are trying to set the CPU clock to $newmhz which is above its specification of $safemhz, doing so may burn down your house, sour milk, or just blow up (OK, not that likely)! Proceed?";echo $?)
                        echo $answer
                        if [ $answer = 1 ]; then exit 1; fi
                else
			answer="n";read -p "You are trying to set the CPU clock to $newmhz which is above its specification of $safemhz, doing so may burn down your house, sour milk, or just blow up (OK, not that likely)! Proceed? [y/n]" -t 10 answer
			echo $answer
                	if [ $answer = n ]; then exit 1; fi
                fi
        fi
 
        if [ $newmhz -le $minmhz ]; then newmhz=$minmhz; fi
        if [ $newmhz -ge $maxmhz ]; then newmhz=$maxmhz; fi
	echo $newmhz > $device
	echo cpu_mhz_max set to $(cat /proc/pandora/cpu_mhz_max)
fi
