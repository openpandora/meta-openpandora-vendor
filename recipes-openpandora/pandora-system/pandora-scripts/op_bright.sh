#!/bin/bash

. /usr/pandora/scripts/op_paths.sh

# get value range
minbright=3
maxbright="$(cat $SYSFS_BACKLIGHT/max_brightness)"
curbright="$(cat $SYSFS_BACKLIGHT/brightness)"

if [ ! $1 ]; then
newbright=$(zenity --scale --text "Set brightness" --min-value=$minbright --max-value=$maxbright --value=$curbright --step 1)
else
newbright=$1
fi
if [ $newbright ]; then
        if [ $newbright -le $minbright ]; then newbright=$minbright; fi
        if [ $newbright -ge $maxbright ]; then newbright=$maxbright; fi
	echo $newbright > $SYSFS_BACKLIGHT_BRIGHTNESS
fi
