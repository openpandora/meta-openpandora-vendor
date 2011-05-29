#!/bin/bash
#actions done when the lid is closed
#only argument is 0 for open 1 for closed
#may also be called after inactivity, like X DPMS

if [ ! -e /tmp/powerstate ]; then #do nothing when in powersave mode
  if [ "$1" = "1" ]; then #lid was closed
    brightness=$(cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness)
    if [ $brightness -gt 0 ]; then
      echo $brightness > /tmp/oldbright
    fi
    echo 0 > /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness
    #echo 1 > /sys/devices/platform/omapfb/graphics/fb0/blank
  elif [ "$1" = "0" ]; then # lid was opened
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
  fi
fi
