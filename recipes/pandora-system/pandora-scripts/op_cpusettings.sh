#!/bin/bash
# Released under the GPL
# CPU-Settings, v1.1, written by Michael Mrozek aka EvilDragon 2011.
# This scripts allows you to change Pandora CPU-Settings.

while mainsel=$(zenity --title="CPU-Settings" --width="400" --height="250" --list --column "id" --column "Please select" --hide-column=1 --text="What do you want to do?" "opp" "Set the max allowed OPP level" "mhz" "Set the minimum / maximum allowed MHz" "warning" "Change warning settings" "defaultmhz" "Set the default MHz"); do

case $mainsel in

  "opp")
    opp="$(cat /etc/pandora/conf/cpu.conf | grep opp | awk -F\: '{print $2}')"
    if zenity --question --title="OPP Setting Info" --text="WARNING!\n\nIncreasing the maximum allowed OPP will allow you to overclock to higher values.\n\nHowever, besides using more power, it ALSO DECREASES THE LIFETIME OF YOUR CPU!\n\nBe absolutely sure you know what you are doing here. \n\nThe standard OPP setting is 3, everything above is out of the specification!" --ok-label="Yes, I know what I'm doing!" --cancel-label="I'm scared!"; then
      if newopp=$(zenity --scale --text "Set the maximum allowed OPP" --min-value=3 --max-value=5 --value=$opp --step 1); then
	echo $newopp > /proc/pandora/cpu_opp_max
	sed -i "s/.*maxopp.*/maxopp:$newopp/g" /etc/pandora/conf/cpu.conf
	zenity --info --title="OPP Set" --text "The maximum allowed OPP value has been set to $newopp." --timeout 6
      else
	zenity --info --title="No change" --text "The maximum OPP value has not been changed." --timeout 6
      fi
    fi;;

"mhz")
    min="$(cat /etc/pandora/conf/cpu.conf | grep min | awk -F\: '{print $2}')"
    max="$(cat /etc/pandora/conf/cpu.conf | grep max: | awk -F\: '{print $2}')"
    if zenity --question --title="MHz Setting Info" --text="This setting can set the allowed range apps can use on your Pandora.\n\nToo high CPU settings can render your Pandora unstable and crash it. This can lead to data loss!\n\nBe absolutely sure you know what you are doing here.\n\nThe standard maximum setting is 800MHz, the standard minimum setting 125MHz." --ok-label="Yes, I know what I'm doing!" --cancel-label="I'm scared!"; then
      if newmax=$(zenity --scale --text "Set the maximum allowed MHz" --min-value=500 --max-value=1300 --value=$max --step 1); then
	if newmin=$(zenity --scale --text "Set the minimum allowed MHz" --min-value=20 --max-value=500 --value=$min --step 1); then
	  sed -i "s/.*max:.*/max:$newmax/g" /etc/pandora/conf/cpu.conf
	  sed -i "s/.*min:.*/min:$newmin/g" /etc/pandora/conf/cpu.conf
	  zenity --info --title="MHz range set" --text "Your Pandora can now set the CPU clock between $newmin and $newmax MHz." --timeout 6
	else
	  zenity --info --title="No change" --text "The CPU Speed has not been changed." --timeout 6
	fi
	else
	zenity --info --title="No change" --text "The CPU Speed has not been changed." --timeout 6
      fi
    fi;;
  
"warning")
    warn="$(cat /etc/pandora/conf/cpu.conf | grep warn | awk -F\: '{print $2}')"
    safe="$(cat /etc/pandora/conf/cpu.conf | grep safe | awk -F\: '{print $2}')"
    min="$(cat /etc/pandora/conf/cpu.conf | grep min | awk -F\: '{print $2}')"
    max="$(cat /etc/pandora/conf/cpu.conf | grep max: | awk -F\: '{print $2}')"
    if zenity --question --title="Warning Setting Info" --text="The Pandora usually displays a warning if you try to overclock.\n\nYou can either select at what speed the warning should appear or disable it completely.\n\nBe absolutely sure you know what you are doing here.\n\nThe standard setting is 600MHz." --ok-label="Yes, I know what I'm doing!" --cancel-label="I'm scared!"; then
      if zenity --question --title="Disable Warning?" --text="Do you want to enable or disable the warning?" --ok-label="Enable it" --cancel-label="Disable it"; then
	if newsafe=$(zenity --scale --text "At what speed should the warning appear?" --min-value=$min --max-value=$max --value=$safe --step 1); then
	  sed -i "s/.*warn.*/warn:yes/g" /etc/pandora/conf/cpu.conf
	  sed -i "s/.*safe.*/safe:$newsafe/g" /etc/pandora/conf/cpu.conf
	  zenity --info --title="Warning enabled" --text "Your Pandora will warn you if you try to clock higher than $newsafe MHz." --timeout 6
	else
	  sed -i "s/.*warn.*/warn:yes/g" /etc/pandora/conf/cpu.conf
	  zenity --info --title="No change" --text "The speed the warning will appear has not been changed and the warning has been enabled." --timeout 6
	fi
      else
	sed -i "s/.*warn.*/warn:no/g" /etc/pandora/conf/cpu.conf
	zenity --info --title="Warning" --text "Your Pandora will NOT warn you if you try to overclock!" --timeout 6
      fi
    fi;;

 "defaultmhz")
    defspeed="$(cat /etc/pandora/conf/cpu.conf | grep default | awk -F\: '{print $2}')"
    min="$(cat /etc/pandora/conf/cpu.conf | grep min | awk -F\: '{print $2}')"
    max="$(cat /etc/pandora/conf/cpu.conf | grep max: | awk -F\: '{print $2}')"
    if zenity --question --title="Default CPU Speed" --text="WARNING!\n\nYou are about to change the default clockspeed your Pandora will be running when you start it.\nIf it is set too high, the Pandora will crash.\n\nIf that happens, the Pandora will NOT change the clockspeed on the next boot, so you can access the OS and fix the default clock speed.\n\nHowever, each crash can lead to data loss - so please be sure to absolutely know what you're doing!" --ok-label="Yes, I know what I'm doing!" --cancel-label="I'm scared!"; then
      if newdefault=$(zenity --scale --text "Set the default CPU speed" --min-value=$min --max-value=$max --value=$defspeed --step 1); then
	echo $newdefault > /proc/pandora/cpu_mhz_max
	sed -i "s/.*default.*/default:$newdefault/g" /etc/pandora/conf/cpu.conf
	zenity --info --title="Default speed set" --text "The default clock speed has been set to $newdefault." --timeout 6
      else
	zenity --info --title="No change" --text "The default CPU speed has not been changed." --timeout 6
      fi
    fi;;


esac
done