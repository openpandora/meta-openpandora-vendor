#!/bin/bash

. /usr/pandora/scripts/op_paths.sh

cur=$(cat $SYSFS_BACKLIGHT_BRIGHTNESS)
max=$(cat $SYSFS_BACKLIGHT/max_brightness)

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

if [ "$new" -gt "$max" ]; then
   new=$max
fi

echo $new > $SYSFS_BACKLIGHT_BRIGHTNESS
