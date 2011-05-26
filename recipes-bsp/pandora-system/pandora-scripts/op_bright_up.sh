#!/bin/bash
cur=$(cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness);
if [ "$cur" -gt "35" ]; then
   new=$(($cur+10))
elif [ "$cur" -gt "20" ]; then 
   new=$(($cur+7))
elif [ "$cur" -gt "13" ]; then 
   new=$(($cur+5))
elif [ "$cur" -gt "5" ]; then 
   new=$(($cur+3))
elif [ "$cur" -gt "0" ]; then 
   new=$(($cur+1))
elif [ "$cur" -eq "0" ]; then 
   new=3
fi

if [ "$new" -gt "54" ]; then
   new=54
fi



echo $new > /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness
