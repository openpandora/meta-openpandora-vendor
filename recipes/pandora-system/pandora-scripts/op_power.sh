#!/bin/bash
#actions done when the power button is pressed
#only argument is the time the button was pressed in  seconds

if [ "$1" -le "2" ]; then # button was pressed 1-2sec, "suspend"
  if [ -e /tmp/powerstate ]; then 
    powerstate=$(cat /tmp/powerstate)
  else
    powerstate=0
  fi
  if [ $powerstate -eq "1" ]; then
    #in lowpower mode
    oldspeed=$(cat /tmp/oldspeed)
    /usr/pandora/scripts/op_cpuspeed.sh $oldspeed
    echo 0 > /tmp/powerstate
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
      hciconfig hci0 up
    fi
    wlstate=$(cat /tmp/wlstate)
    if [ ! $wlstate ]; then
      /etc/init.d/wl1251-init start
    fi
    pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
    for PID in $pidlist
    do
      kill -18 $PID #send SIGCONT
    done
    echo 255 > /sys/class/leds/pandora\:\:power/brightness #power LED bright
    rm /tmp/powerstate
  else
    #in normal mode
    echo 1 > /tmp/powerstate
    cat /proc/pandora/cpu_mhz_max > /tmp/oldspeed
    cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness > /tmp/oldbright
    pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
    for PID in $pidlist
    do
      kill -19 $PID #send SIGSTOP
    done
    rm /tmp/hcistate
    hcistate=$(hciconfig hci0 | grep DOWN)
    if [ $hcistate ]; then
	echo "down" > /tmp/hcistate
    else
	hciconfig hci0 down
    fi
    rm /tmp/wlstate
    wlstate=$(lsmod | grep -m1 wl1251)
    if [ ! $wlstate ]; then
    	echo "down" > /tmp/wlstate
    else
	    /etc/init.d/wl1251-init stop
    fi
    echo 0 > /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness
    echo 1 > /sys/devices/platform/omapfb/graphics/fb0/blank
    echo 16 > /sys/class/leds/pandora\:\:power/brightness #dim power LED
    /usr/pandora/scripts/op_cpuspeed.sh 125
  fi
elif [ "$1" -ge "3" ]; then #button was pressed 3 sec or longer, shutdown
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
  shutdown -h now
  else
  su -c 'DISPLAY=:0.0  zenity --error --text "Shutdown aborted!"' $xfceuser
  fi
fi

