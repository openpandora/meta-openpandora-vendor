#!/bin/sh

# Set the timezone and date/time

while mainsel=$(zenity --title="Date / Time / Timezone" --width="400" --height="250" --list --column "id" --column "Please select" --hide-column=1 --text="You can set the time and date or select a different timezone.\n" "td" "Change Time and Date" "tz" "Select Timezone" --ok-label="Change Setting" --cancel-label="Exit"); do


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

  while ! date=$(zenity --calendar --text="Please select the current date" --title "Please select the current date" --day=$date_d --month=$date_m --year=$date_y --date-format="%Y%m%d" --width=500) || [ "x$date" = "x" ] ; do
	  zenity --title="Error" --error --text="Please select the date." --timeout 6
  done

  echo $date

  time_h=`date +%H`
  time_m=`date +%M`

  while ! time=$(zenity --title="Enter actual time" --entry --text "Please enter the time in 24hour format (HH:MM).\n\nThe screen might blank out after you changed the time.\nDon't panic. Simply press a button on the keyboard.\n" --entry-text "$time_h:$time_m") || [ "x$time" = "x" ] ; do
	  zenity --title="Error" --error --text="Please input the time." --timeout 6
  done

  while ! date -d $time ; do
	  time=$(zenity --title="Enter actual time" --entry --text "Please enter the time in 24hour format (HH:MM).\n\nThe screen might blank out after you changed the time.\nDon't panic. Simply press a button on the keyboard.\n" --entry-text "$time_h:$time_m")
  done
  date +%Y%m%d -s $date
  date +%H:%M -s $time
  ;;

esac
done 