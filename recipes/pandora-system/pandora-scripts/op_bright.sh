#!/bin/bash
#get value range
minbright=3
maxbright="$(cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/max_brightness)"
curbright="$(cat /sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness)"
device=/sys/devices/platform/twl4030-pwm0-bl/backlight/twl4030-pwm0-bl/brightness
if [ ! $1 ]; then
newbright=$(zenity --scale --text "Set brightness" --min-value=$minbright --max-value=$maxbright --value=$curbright --step 1)
else
newbright=$1
fi
if [ $newbright ]; then
        if [ $newbright -le $minbright ]; then newbright=$minbright; fi
        if [ $newbright -ge $maxbright ]; then newbright=$maxbright; fi
	echo $newbright > $device
fi
