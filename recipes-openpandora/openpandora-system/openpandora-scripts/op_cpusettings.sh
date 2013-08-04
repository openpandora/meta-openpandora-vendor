#!/bin/bash
# Released under the GPL
# CPU-Settings, v1.1, written by Michael Mrozek aka EvilDragon 2011.
# This scripts allows you to change Pandora CPU-Settings.

# First, check for the unit type and set maximum possible OPP.

pnd_version=$(cat /tmp/pnd_version)
if [ "$pnd_version" == "OMAP3630" ]; then
    oppsys="4"
  else
    oppsys="5"
fi

while mainsel=$(zenity --title="CPU-Settings" --width="400" --height="380" --list --column "id" --column "Please select" --hide-column=1 --text="Welcome to the CPU-Settings.\nHere, you can configure the behaviour of your CPU \nThis can make your Pandora run faster but also more unstable.\n\nDon't worry though, you cannot permanently damage your unit.\n\nWhat do you want to do?\n" "profile" "Quick-Setup: Select from different profiles" "opp" "Set the max allowed OPP level" "mhz" "Set the maximum allowed MHz" "warning" "Change warning settings" "defaultmhz" "Set the default maximum MHz" --ok-label="Change Setting" --cancel-label="Exit"); do

case $mainsel in
 
  "profile")
  
    if [ "$pnd_version" == "OMAP3630" ]; then 
      cpusel=$(zenity --title="Optional settings" --width="400" --height="300" --list --column "id" --column "Please select" --hide-column=1 --text="The CPU of the Pandora supports different speed settings.\nHigher speeds might make some units unstable and decrease the lifetime of your CPU.\n\nBelow are some quick profiles which will help you to configure your system the way you like it.\n" "1200" "Clockspeed: 1,2Ghz, OPP4 (probably unstable)" "1100" "Clockspeed: 1,1Ghz, OPP4 (should be stable)" "1000" "Clockspeed: 1GHz, OPP4 (Default Speed)" --ok-label="Select CPU Profile" )
    else
      cpusel=$(zenity --title="Optional settings" --width="400" --height="300" --list --column "id" --column "Please select" --hide-column=1 --text="The CPU of the Pandora supports different speed settings.\nHigher speeds might make some units unstable and decrease the lifetime of your CPU.\n\nBelow are some quick profiles which will help you to configure your system the way you like it.\n" "900" "Clockspeed: 900Mhz, OPP5 (probably unstable)" "800" "Clockspeed: 800Mhz, OPP5 (should be stable)" "600" "Clockspeed: 600MHz, OPP3 (Default Speed)" --ok-label="Select CPU Profile" )
    fi
    
    case $cpusel in
	"1200")
	echo 4 > /proc/pandora/cpu_opp_max
	sed -i "s/.*maxopp.*/maxopp:4/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*max:.*/max:1300/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*default.*/default:1200/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*safe.*/safe:1200/g" /etc/pandora/conf/cpu.conf
	sync
	/usr/pandora/scripts/op_cpuspeed.sh -n 1200
	zenity --info --title="CPU Speed set" --text "The maximum CPU Speed has been set to 1,2GHz." --timeout 6
	;;
    
        "1100")
	echo 4 > /proc/pandora/cpu_opp_max
	sed -i "s/.*maxopp.*/maxopp:4/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*max:.*/max:1200/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*default.*/default:1100/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*safe.*/safe:1100/g" /etc/pandora/conf/cpu.conf
	sync
	/usr/pandora/scripts/op_cpuspeed.sh -n 1100
	zenity --info --title="CPU Speed set" --text "The maximum CPU Speed has been set to 1,1GHz." --timeout 6
	;;

	"1000")
	echo 4 > /proc/pandora/cpu_opp_max
	sed -i "s/.*maxopp.*/maxopp:4/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*max:.*/max:1100/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*default.*/default:1000/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*safe.*/safe:1000/g" /etc/pandora/conf/cpu.conf
	sync
	/usr/pandora/scripts/op_cpuspeed.sh -n 1000
	zenity --info --title="CPU Speed set" --text "The maximum CPU Speed has been set to 1GHz." --timeout 6
	;;	

	"900")
	echo 5 > /proc/pandora/cpu_opp_max
	sed -i "s/.*maxopp.*/maxopp:5/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*max:.*/max:950/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*default.*/default:900/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*safe.*/safe:900/g" /etc/pandora/conf/cpu.conf
	sync
	/usr/pandora/scripts/op_cpuspeed.sh -n 900
	zenity --info --title="CPU Speed set" --text "The maximum CPU Speed has been set to 900MHz." --timeout 6
	;;
	
	"800")
	echo 5 > /proc/pandora/cpu_opp_max
	sed -i "s/.*maxopp.*/maxopp:5/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*max:.*/max:900/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*default.*/default:800/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*safe.*/safe:800/g" /etc/pandora/conf/cpu.conf
	sync
	/usr/pandora/scripts/op_cpuspeed.sh -n 800
	zenity --info --title="CPU Speed set" --text "The maximum CPU Speed has been set to 800MHz." --timeout 6
	;;


	"600")
	echo 3 > /proc/pandora/cpu_opp_max
	sed -i "s/.*maxopp.*/maxopp:3/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*max:.*/max:700/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*default.*/default:600/g" /etc/pandora/conf/cpu.conf
	sed -i "s/.*safe.*/safe:600/g" /etc/pandora/conf/cpu.conf
	sync
	/usr/pandora/scripts/op_cpuspeed.sh -n 600
	zenity --info --title="CPU Speed set" --text "The maxmimum CPU Speed has been set to 600Mhz." --timeout 6
	;;

    esac
    ;;

  "opp")
    opp="$(cat /etc/pandora/conf/cpu.conf | grep opp | awk -F\: '{print $2}')"
    if zenity --question --title="OPP Setting Info" --text="WARNING!\n\nIncreasing the maximum allowed OPP will allow you to overclock to higher values.\n\nHowever, besides using more power, it ALSO DECREASES THE LIFETIME OF YOUR CPU!" --ok-label="Yes, I know what I'm doing!" --cancel-label="I'm scared!"; then
      if newopp=$(zenity --scale --text "Set the maximum allowed OPP" --min-value=3 --max-value=$oppsys --value=$opp --step 1); then
	echo $newopp > /proc/pandora/cpu_opp_max
	sed -i "s/.*maxopp.*/maxopp:$newopp/g" /etc/pandora/conf/cpu.conf
	sync
	zenity --info --title="OPP Set" --text "The maximum allowed OPP value has been set to $newopp." --timeout 6
      else
	zenity --info --title="No change" --text "The maximum OPP value has not been changed." --timeout 6
      fi
    fi;;

"mhz")
    min="$(cat /etc/pandora/conf/cpu.conf | grep min | awk -F\: '{print $2}')"
    max="$(cat /etc/pandora/conf/cpu.conf | grep max: | awk -F\: '{print $2}')"
    defspeed="$(cat /etc/pandora/conf/cpu.conf | grep default | awk -F\: '{print $2}')"
    if zenity --question --title="MHz Setting Info" --text="This setting can set the allowed range apps can use on your Pandora.\n\nToo high CPU settings can render your Pandora unstable and crash it. This can lead to data loss!\n\nBe absolutely sure you know what you are doing here.\n\n" --ok-label="Yes, I know what I'm doing!" --cancel-label="I'm scared!"; then
      if newmax=$(zenity --scale --text "Set the maximum allowed MHz" --min-value=500 --max-value=1300 --value=$max --step 1); then
	  sed -i "s/.*max:.*/max:$newmax/g" /etc/pandora/conf/cpu.conf
	  if [ "$defspeed" -gt "$newmax" ]; then
	    sed -i "s/.*default.*/default:$newmax/g" /etc/pandora/conf/cpu.conf
	    zenity --info --title="Default speed info" --text "As your default speed was set higher than your new maximum, it has been changed to the new maximum speed." --timeout 6
	    sync
	    /usr/pandora/scripts/op_cpuspeed.sh -n $newmax
	  fi
	  zenity --info --title="MHz range set" --text "The maximum allowed CPU Speed of your Pandora is now $newmax MHz.\n\n" --timeout 6
	else
	  zenity --info --title="No change" --text "The CPU Speed has not been changed." --timeout 6
      fi
    fi;;
  
"warning")
    warn="$(cat /etc/pandora/conf/cpu.conf | grep warn | awk -F\: '{print $2}')"
    safe="$(cat /etc/pandora/conf/cpu.conf | grep safe | awk -F\: '{print $2}')"
    min="$(cat /etc/pandora/conf/cpu.conf | grep min | awk -F\: '{print $2}')"
    max="$(cat /etc/pandora/conf/cpu.conf | grep max: | awk -F\: '{print $2}')"
    if zenity --question --title="Warning Setting Info" --text="The Pandora can display a warning if you try to overclock.\n\nYou can either select at what speed the warning should appear or disable it completely.\n\nBe absolutely sure you know what you are doing here.\n\nThe standard setting is 600MHz." --ok-label="Yes, I know what I'm doing!" --cancel-label="I'm scared!"; then
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
	sync
	/usr/pandora/scripts/op_cpuspeed.sh -n $newdefault
	sed -i "s/.*default.*/default:$newdefault/g" /etc/pandora/conf/cpu.conf
	zenity --info --title="Default speed set" --text "The default clock speed has been set to $newdefault." --timeout 6
      else
	zenity --info --title="No change" --text "The default CPU speed has not been changed." --timeout 6
      fi
    fi;;


esac
done
