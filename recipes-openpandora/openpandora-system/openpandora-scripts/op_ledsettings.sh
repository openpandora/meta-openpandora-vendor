#!/bin/bash
# Released under the GPL
# LED-Settings, v1.0, written by Michael Mrozek aka EvilDragon 2013.

 . /usr/pandora/scripts/op_paths.sh

while mainsel=$(zenity --title="LED-Settings" --width="400" --height="370" --list --column "id" --column "Please select" --hide-column=1 --text="Welcome to the LED-Settings-Dialogue.\n\nWhat do you want to do?\n" "normal" "Set Power LED Brightness (normal mode)" "power" "Set Power LED Brightness (powersave)" "sd1" "Enable / Disable SD1 LED" "sd2" "Enable / Disable SD2 LED" "wifi" "Enable / Disable WiFi LED" "bt" "Enable / Disable Bluetooth LED"  --ok-label="Change Setting" --cancel-label="Exit"); do

case $mainsel in

  "normal")
   curbright=$(cat /etc/pandora/conf/led.conf | grep HighPowerLED: | awk -F\: '{print $2}')
   while newbright=$(zenity --scale --text "Set brightness of Power LED (normal mode)" --min-value=0 --max-value=255 --value=$curbright --step 1 --ok-label="Set new brightness" --cancel-label="Save and exit"); do
      curbright=$newbright
      echo $curbright > /sys/class/leds/pandora\:\:power/brightness
   done
   sed -i "s/.*HighPowerLED.*/HighPowerLED:$curbright/g" /etc/pandora/conf/led.conf 
   zenity --info --title="Power LED Brightness Set" --text "The new power LED Brightness setting has been saved." --timeout 6
   ;;   
  
  "power")
   normbright=$(cat /sys/class/leds/pandora\:\:power/brightness)
   curbright=$(cat /etc/pandora/conf/led.conf | grep LowPowerLED: | awk -F\: '{print $2}')
   echo $curbright > /sys/class/leds/pandora\:\:power/brightness
   while newbright=$(zenity --scale --text "Set brightness of Power LED (Powersave mode)" --min-value=0 --max-value=255 --value=$curbright --step 1 --ok-label="Set new brightness" --cancel-label="Save and exit"); do
      curbright=$newbright
      echo $curbright > /sys/class/leds/pandora\:\:power/brightness
   done
   sed -i "s/.*LowPowerLED.*/LowPowerLED:$curbright/g" /etc/pandora/conf/led.conf 
   zenity --info --title="Power LED Brightness Set" --text "The new power LED Brightness setting (Powersave mode) has been saved." --timeout 6
   echo $normbright > /sys/class/leds/pandora\:\:power/brightness
   ;;   
  
  "sd1")
  if zenity --question --title="Enable / Disable LED?" --text="Do you want to enable or disable the LED for SD Card 1?" --ok-label="Enable it" --cancel-label="Disable it"; then
    echo mmc0 > /sys/class/leds/pandora\:\:sd1/trigger
    sed -i "s/.*pandora::sd1.*/pandora::sd1 mmc0/g" /etc/default/leds 
  else
    echo none > /sys/class/leds/pandora\:\:sd1/trigger
    sed -i "s/.*pandora::sd1.*/pandora::sd1 none/g" /etc/default/leds 
  fi
  ;;
  
  "sd2")
  if zenity --question --title="Enable / Disable LED?" --text="Do you want to enable or disable the LED for SD Card 2?" --ok-label="Enable it" --cancel-label="Disable it"; then
    echo mmc1 > /sys/class/leds/pandora\:\:sd2/trigger
    sed -i "s/.*pandora::sd2.*/pandora::sd2 mmc1/g" /etc/default/leds 
  else
    echo none > /sys/class/leds/pandora\:\:sd2/trigger
    sed -i "s/.*pandora::sd2.*/pandora::sd2 none/g" /etc/default/leds 
  fi
  ;;
  
  "bt")
  if zenity --question --title="Enable / Disable LED?" --text="Do you want to enable or disable the LED for the Bluetooth LED?" --ok-label="Enable it" --cancel-label="Disable it"; then
    echo bluetooth > /sys/class/leds/pandora\:\:bluetooth/trigger
    sed -i "s/.*pandora::bluetooth.*/pandora::bluetooth bluetooth/g" /etc/default/leds 
    if hciconfig "$INTERFACE" | grep UP &>/dev/null
    then
        echo default-on > /sys/class/leds/pandora\:\:bluetooth/trigger
	echo 255 > /sys/class/leds/pandora\:\:bluetooth/brightness
    fi
  else
    echo none > /sys/class/leds/pandora\:\:bluetooth/trigger
    sed -i "s/.*pandora::bluetooth.*/pandora::bluetooth none/g" /etc/default/leds 
  fi
  ;;
  
  "wifi")
  if zenity --question --title="Enable / Disable LED?" --text="Do you want to enable or disable the WiFi LED?" --ok-label="Enable it" --cancel-label="Disable it"; then
    sed -i "s/.*pandora::wifi.*/pandora::wifi phy0radio/g" /etc/default/leds 
    if [ "`lsmod | grep wl1251`" ]
    then
        phy_idx=0
	for a in `seq 20` ; do
		if [ -e /sys/class/net/wlan0 ] ; then
			phy_idx=$(cat /sys/class/net/wlan0/phy80211/index)
			break
		else
			sleep 0.2
		fi
	done

	# restore phy related LED triggers (they come from mac80211.ko)
	if [ -e /sys/class/leds/ ] ; then
		for led in /sys/class/leds/* ; do
			trigger=$(grep "$(basename $led)" /etc/default/leds | grep phy | \
					awk '{print $2}' | sed -e 's/.*phy[0-9]*\(.*\)/\1/')
			if [ "x$trigger" != "x" ] ; then
				echo "phy${phy_idx}$trigger" > "$led/trigger"
			fi
		done
	fi
    fi
    zenity --info --title="WiFi LED Set" --text "The WiFi LED has been enabled.\nPlease note: You need to disable and re-enable WiFi before it switches on again." --timeout 6
  else
    echo none > /sys/class/leds/pandora\:\:wifi/trigger
    sed -i "s/.*pandora::wifi.*/pandora::wifi none/g" /etc/default/leds 
  fi
  ;;
esac
done

