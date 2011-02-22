#!/bin/bash
 
#HUP all apps who happen to look into one of the .desktop locations
 
PIDS=$(lsof +d /usr/share/applications  /usr/local/share/applications/ /home/*/Desktop /home/*/.applications /home/*/.local/share/applications | awk '!/PID/ {print $2 }' | uniq)
for pid in $PIDS; do
        kill -HUP $pid
done
