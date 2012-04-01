#!/bin/bash
#get value range
minmhz="$(cat /etc/pandora/conf/cpu.conf | grep 'min:' | awk -F\: '{print $2}')"
safemhz="$(cat /etc/pandora/conf/cpu.conf | grep 'safe:' | awk -F\: '{print $2}')"
maxmhz="$(cat /etc/pandora/conf/cpu.conf | grep 'max:' | awk -F\: '{print $2}')"
warn="$(cat /etc/pandora/conf/cpu.conf | grep 'warn:' | awk -F\: '{print $2}')"
device=/proc/pandora/cpu_mhz_max
curmhz="$(cat $device)"
newmhz="$(cat $device)"
kernel_major=`uname -r | cut -c 1`

if [ ! -e $device ]; then
    if [ -z "$1" -a -n "$DISPLAY" ]; then
        zenity --info --title="CPU-Settings not supported" --text \
            "Sorry, the experimental kernel does not support setting the clockspeed (yet)."
    fi
    exit 1
fi

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
        if [ $newmhz -gt $safemhz ]; then
		if [ $warn != no ]; then 
                	if [ $DISPLAY ]; then
                	        answer=$(zenity --question --title "Alert" --text "You are trying to set the CPU clock to $newmhz which is above the warning level of $safemhz, doing so may burn down your house, sour milk, or just blow up (OK, not that likely)! Proceed?";echo $?)
                	        echo $answer
                	        if [ $answer = 1 ]; then exit 1; fi
                	else
				answer="n";read -p "You are trying to set the CPU clock to $newmhz which is above the warning level of $safemhz, doing so may burn down your house, sour milk, or just blow up (OK, not that likely)! Proceed? [y/n]" -t 10 answer
				echo $answer
                		if [ $answer = n ]; then exit 1; fi
                	fi
		fi
        fi
 
        if [ $newmhz -le $minmhz ]; then newmhz=$minmhz; fi
        if [ $newmhz -ge $maxmhz ]; then newmhz=$maxmhz; fi
	echo $newmhz > $device
	echo cpu_mhz_max set to $(cat $device)

	if [ -e /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
		# must poke cpufreq so it does the actual clock transition
		# according to new limits
		gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
		echo $gov > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	fi
fi
