#!/bin/sh

# Set the timezone and date/time

while mainsel=$(zenity --title="Date / Time / Timezone" --width="400" --height="250" --list --column "id" --column "Please select" --hide-column=1 --text="You can set the time and date or select a different timezone.\n" "td" "Change Time and Date" "tz" "Select Timezone" "sync" "Sync time over Internet" --ok-label="Change Setting" --cancel-label="Exit"); do


case $mainsel in

  "tz")

    while ! area=$(zenity --list --title "Select your time zone" --text="Please select your area" --column="Select your area" --print-column=1 "Africa" "America" "Asia" "Australia" "Europe" "Pacific" --width=500 --height=260) || [ "x$area" = "x" ] ; do
	  zenity --title="Error" --error --text="Please select your area." --timeout=6
    done

    while ! timezone=$(ls -1 /usr/share/zoneinfo/$area | zenity ---width=500 --height=200 --title="Select your closest location" --list --column "Closest Location" --text "Please select the location closest to you") || [ "x$timezone" = "x" ] ; do
	   zenity --title="Error" --error --text="Please select your location." --timeout=6
    done

    echo $timezone
    rm /etc/localtime && ln -s /usr/share/zoneinfo/$area/$timezone /etc/localtime
  ;;

  "td")

  #Make sure we clean up any leading zeros in the day (as Zenity freaks out)
  date_d=`date +%d | sed 's/^0//'`
  date_m=`date +%m | sed 's/^0//'`
  date_y=`date +%Y`

  date=""
  while [ "x$date" = "x" ] ; do
    date=$(zenity --calendar --text="Please select the current date" --title "Please select the current date" --day=$date_d --month=$date_m --year=$date_y --date-format="%Y%m%d" --width=500) || exit 1
  done

  echo $date

  time_h=`date +%H`
  time_m=`date +%M`

  while true; do
    time=$(zenity --title="Enter actual time" --entry --text "Please enter the time in 24hour format (HH:MM).\n" --entry-text "$time_h:$time_m") || exit 1
    if test -n "$time" && date -d "$time"; then
      break;
    fi
    zenity --title="Error" --error --text="Please input the time." --timeout 6
  done

  # take care of screensaver first
  screensaver_enabled=true
  if xset q | grep -A2 'Screen Saver' | grep -q 'timeout:.*\<0\>.*cycle'; then
    screensaver_enabled=false
  fi
  xset s off

  date +%Y%m%d -s $date
  date +%H:%M -s $time
  hwclock -u -w

  if $screensaver_enabled; then
    xset s on
  fi
  ;;
  "sync")
  screensaver_enabled=true
  if xset q | grep -A2 'Screen Saver' | grep -q 'timeout:.*\<0\>.*cycle'; then
    screensaver_enabled=false
  fi
  xset s off
  (
  test -e /etc/init.d/ntpd && sudo /etc/init.d/ntpd stop
  sudo ntpdate pool.ntp.org
  ) |
	zenity --progress \
	--title="Syncing..." \
	--text="Syncing with time server...\nPlease wait a while..." \
	--pulsate
  test -e /etc/init.d/ntpd && sudo /etc/init.d/ntpd start
  if $screensaver_enabled; then
    xset s on
  fi
  ;;
esac
done 
