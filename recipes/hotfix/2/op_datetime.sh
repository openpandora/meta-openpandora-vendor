#!/bin/sh

# Set the timezone and date/time

while ! timezone=$(zenity --list --title "Select your time zone" --text="Please select your time zone" --column="Select your time zone" --print-column=1 "GMT (London, Lisbon, Portugal, Casablanca, Morocco)" "GMT+1 (Paris, Berlin, Amsterdam, Bern, Stockholm)" "GMT+2 (Athens, Helsinki, Istanbul)" "GMT+3 (Kuwait, Nairobi, Riyadh, Moscow)" "GMT+4 (Abu Dhabi, Iraq, Muscat, Kabul)" "GMT+5 (Calcutta, Colombo, Islamabad, Madras, New Delhi)" "GMT+6 (Almaty, Dhakar, Kathmandu)" "GMT+7 (Bangkok, Hanoi, Jakarta)" "GMT+8 (Beijing, Hong Kong, Kuala Lumpar, Singapore, Taipei)" "GMT+9 (Osaka, Seoul, Sapporo, Tokyo, Yakutsk)" "GMT+10 (Brisbane, Melbourne, Sydney, Vladivostok)" "GMT+11 (Magadan, New Caledonia, Solomon Is)" "GMT+12 (Auckland, Fiji, Kamchatka, Marshall Is., Wellington, Suva)" "GMT-1 (Azores, Cape Verde Is.)" "GMT-2 (Mid-Atlantic)" "GMT-3 (Brasilia, Buenos Aires, Georgetown)" "GMT-4 (Atlantic Time, Caracas)" "GMT-5 (Bogota, Lima, New York)" "GMT-6 (Mexico City, Saskatchewan, Chicago, Guatamala)" "GMT-7 (Denver, Edmonton, Mountain Time, Phoenix, Salt Lake City)" "GMT-8 (Anchorage, Los Angeles, San Francisco, Seattle)" "GMT-9 (Alaska)" "GMT-10 (Hawaii, Honolulu)" "GMT-11 (Midway Island, Samoa)" "GMT-12 (Eniwetok, Kwaialein)" "UTC" "Universal" --width=500 --height=450) || [ "x$timezone" = "x" ] ; do
	zenity --title="Error" --error --text="Please select a time zone." --timeout=6
done
timezone=`echo $timezone | sed  's/(.*)//g'`
echo $timezone
echo rm /etc/localtime && ln -s /usr/share/zoneinfo/Etc/$timezone /etc/localtime

#Make sure we clean up any leading zeros in the day (as Zenity freaks out)
date_d=`date +%d | sed 's/^0//'`
date_m=`date +%m`
date_y=`date +%Y`


while ! date=$(zenity --calendar --text="Please select the current date" --title "Please select the current date" --day=$date_d --month=$date_m --year=$date_y --date-format="%Y%m%d" --width=500) || [ "x$date" = "x" ] ; do
        zenity --title="Error" --error --text="Please select the date." --timeout 6
done

echo $date

time_h=`date +%H`
time_m=`date +%M`

while ! time=$(zenity --title="Enter actual time" --entry --text "Please enter the time in 24hour format (HH:MM):" --entry-text "$time_h:$time_m") || [ "x$time" = "x" ] ; do
        zenity --title="Error" --error --text="Please input the time." --timeout 6
done

while ! date -d $time ; do
	time=$(zenity --title="Enter actual time" --entry --text "Please enter the time in 24hour format (HH:MM):" --entry-text "$time_h:$time_m")
done
 
date +%Y%m%d -s $date
date +%H:%M -s $time
