#!/bin/bash
#usage op_shutdown.sh time in seconds

user=$(cat /tmp/currentuser)

time=$1
if [ x$time = "x" ]; then
	time=30
fi
countdown () {
  for i in $(seq $time); do
    percentage=$(echo $i $time | awk '{ printf("%f\n", $1/$2*100) }')
    echo $percentage
    remain=$(echo $time $i | awk '{ printf("%d\n", $1-$2) }')
    echo "# Low power, shutdown in $remain"
    sleep 1
  done
}
countdown  | su -c 'DISPLAY=:0.0  zenity --progress --auto-close --text "Shutdown" --title "Shutdown"' $user
if [ $? -eq 0 ]; then
    shutdown -h now
else
    su -c 'DISPLAY=:0.0  zenity --error --text "`printf "Shutdown aborted! \n
Please plug in the charger ASAP or shutdown manually, the System will crash in a few minutes"`"' $user
fi
