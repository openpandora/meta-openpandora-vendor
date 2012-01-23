#!/bin/bash

( test -e /tmp/op_power.lock && exit 2 ) || touch "/tmp/op_power.lock"

debug(){
	return 1 # 0 when debugging, 1 when not
}

test -e $(grep /etc/passwd -e $(ps u -C xfce4-session | tail -n1 | awk '{print $1}')| cut -f 6 -d ":")/.lidconfig && lidconfig=$(cat $(grep /etc/passwd -e $(ps u -C xfce4-session | tail -n1 | awk '{print $1}')| cut -f 6 -d ":")/.lidconfig) # read lid conf. file if it exists

#powerbuttonconfig=$(cat $(grep /etc/passwd -e $(ps u -C xfce4-session | tail -n1 | awk '{print $1}')| cut -f 6 -d ":")/.powerbuttonconfig)

  if [ -e /tmp/powerstate ]; then 
	powerstate="$(cat /tmp/powerstate)"
else
	powerstate="on"
fi

debug && echo "powerstate=$powerstate"

lowPowerOn(){ #switch from normal to lowpower mode
	cat /proc/pandora/cpu_mhz_max > /tmp/oldspeed
	cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness > /tmp/oldbright
	pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
	for PID in $pidlist
	do
		kill -19 $PID #send SIGSTOP
	done
	test -f /tmp/hcistate && rm /tmp/hcistate
	hcistate=$(hciconfig hci0 | grep DOWN)
	if [ $hcistate ]; then
		echo "down" > /tmp/hcistate
	else
		hciconfig hci0 down
	fi
	test -f /tmp/wlstate && rm /tmp/wlstate
	wlstate=$(lsmod | grep -m1 wl1251)
	if [ -z "$wlstate" ]; then
		echo "down" > /tmp/wlstate
  else
		ifconfig wlan0 down
		rmmod board_omap3pandora_wifi wl1251_sdio wl1251
  fi
	echo 0 > /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness
	echo 1 > /sys/devices/platform/omapfb/graphics/fb0/blank
	echo 16 > /sys/class/leds/pandora\:\:power/brightness #dim power LED
	/usr/pandora/scripts/op_cpuspeed.sh 125
}

lowPowerOff(){ # switch from lowpower to normal mode
    oldspeed=$(cat /tmp/oldspeed)
    /usr/pandora/scripts/op_cpuspeed.sh $oldspeed
    oldbright=$(cat /tmp/oldbright)
    maxbright=$(cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/max_brightness)
    echo 0 > /sys/devices/platform/omapfb/graphics/fb0/blank
    sleep 0.1s # looks cleaner, could flicker without
    oldspeed=$(cat /tmp/oldspeed)
    if [ $oldbright -ge 3 ] && [ $oldbright -le $maxbright ]; then 
      /usr/pandora/scripts/op_bright.sh $oldbright 
    else
      /usr/pandora/scripts/op_bright.sh $maxbright
    fi
    hcistate=$(cat /tmp/hcistate)
    if [ ! $hcistate ]; then
      hciconfig hci0 up pscan
    fi
    wlstate=$(cat /tmp/wlstate)
	if [ -z "$wlstate" ]; then
      /etc/init.d/wl1251-init start
    fi
    pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
    for PID in $pidlist
    do
      kill -18 $PID #send SIGCONT
    done
    echo 255 > /sys/class/leds/pandora\:\:power/brightness #power LED bright
}

shutdown(){ # warns the user and shuts the pandora down
  xfceuser=$(ps u -C xfce4-session | tail -n1 | awk '{print $1}')
  time=5
  countdown () {
    for i in $(seq $time); do
      precentage=$(echo $i $time | awk '{ printf("%f\n", $1/$2*100) }')
      echo $precentage
      echo "# Shutdown in $(($time-$i))"
      sleep 1
    done
  }
  countdown  | su -c 'DISPLAY=:0.0  zenity --progress --auto-close --text "Shutdown in X" --title "Shutdown"' $xfceuser
  if [ $? -eq 0 ]; then
	/sbin/shutdown -h now
  else
  su -c 'DISPLAY=:0.0  zenity --error --text "Shutdown aborted!"' $xfceuser
  fi
}

displayOn(){ # turns the display on
	#echo 0 > /sys/devices/platform/omapfb/graphics/fb0/blank
	#sleep 0.1s # looks cleaner, could flicker without
	maxbright=$(cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/max_brightness)
	oldbright=0
	if [ -f /tmp/oldbright ]; then
		oldbright=$(cat /tmp/oldbright)
	fi
	if [ $oldbright -eq 0 ]; then
		oldbright=$(cat /etc/pandora/conf/brightness.state)
	fi
	if [ $oldbright -ge 3 ] && [ $oldbright -le $maxbright ]; then 
		/usr/pandora/scripts/op_bright.sh $oldbright 
	else
		/usr/pandora/scripts/op_bright.sh $maxbright
fi
}

displayOff(){ # turns the display off
	brightness=$(cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness)
	if [ $brightness -gt 0 ]; then
		echo $brightness > /tmp/oldbright
	fi
	echo 0 > /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness
	#echo 1 > /sys/devices/platform/omapfb/graphics/fb0/blank
}

if [[ "$2" == "" ]]; then
	if [[ "$1" -le 2 ]]; then # power button was pressed 1-2sec, "suspend"
		if [[ "$powerstate" == "buttonlowpower" ]]; then
			(debug && echo "lowPowerOff") || lowPowerOff
			powerstate="on"
		elif [[ "$powerstate" == "on" ]]; then
			(debug && echo "lowPowerOn") || lowPowerOn
			powerstate="buttonlowpower"
		fi
	elif [[ "$1" -ge 3 ]]; then # power button was pressed 3 sec or longer, shutdown
		if [[ "$powerstate" == "on" ]]; then
			(debug && echo "shutdown") || shutdown
		fi
	fi
elif [[ "$2" == "lid" ]]; then
	if [[ "$1" == 0 ]]; then # lid was opened
		if [[ "$powerstate" == lid* ]]; then
			case "$lidconfig" in
				"lowpower")
					(debug && echo "lowPowerOff") || lowPowerOff
					powerstate="on"
				;;
				*)
					(debug && echo "displayOn") || displayOn
					powerstate="on"
				;;
			esac
		fi
	elif [[ "$1" == 1 ]]; then # lid was closed
		if [[ "$powerstate" == "on" ]]; then
			case "$lidconfig" in
				"shutdown")
					(debug && echo "shutdown") || shutdown
				;;
				"lowpower")
					(debug && echo "lowPowerOn") || lowPowerOn
					powerstate="lidlowpower"
				;;
				*)
					(debug && echo "displayOff") || displayOff
					powerstate="liddisplayoff"
				;;
			esac
		fi
	fi
 fi
debug && echo "powerstate=$powerstate"
echo "$powerstate" > /tmp/powerstate


