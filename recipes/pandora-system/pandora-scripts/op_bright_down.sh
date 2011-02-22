#!/bin/bash
cur=$(cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness);
if [ "$cur" -gt "40" ]; then
   new=$(($cur-10))
elif [ "$cur" -gt "30" ]; then 
   new=$(($cur-7))
elif [ "$cur" -gt "20" ]; then 
   new=$(($cur-5))
elif [ "$cur" -gt "5" ]; then 
   new=$(($cur-3))
elif [ "$cur" -gt "0" ]; then 
   new=$(($cur-1))
fi

if [ "$new" -lt "3" ]; then
   new=0
fi

echo $new > /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness
