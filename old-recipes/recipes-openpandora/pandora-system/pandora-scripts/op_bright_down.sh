#!/bin/bash

. /usr/pandora/scripts/op_paths.sh

cur=$(cat $SYSFS_BACKLIGHT_BRIGHTNESS)
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

echo $new > $SYSFS_BACKLIGHT_BRIGHTNESS
