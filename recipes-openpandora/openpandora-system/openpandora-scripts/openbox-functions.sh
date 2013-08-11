#!/bin/bash
#
# script name: openbox-functions.sh
# author: freamon
# released under the GPL


# This script is called when entries in the Root Menu and its submenus are selected.
#
# Web Browser (calls openbox-functions.sh loadprog webbrowser)  
# PND Installer (calls openbox-functions.sh loadprog pndinstaller)
# Connectivity -> (displays output provided by openbox-functions.sh togglemenu)
#							 -> WiFi Hardware ON (calls openbox-functions.sh togglemenu wifi_ON)
#							 -> WiFi Hardware Off (calls openbox-functions.sh togglemenu wifi_OFF)
#							 -> WiFi Applet ON (calls openbox-functions.sh togglemenu networkapp_ON)
#							 -> WiFi Applet OFF (calls openbox-functions.sh togglemenu networkapp_OFF)
#							 -> Bluetooth Hardware ON (calls openbox-functions.sh togglemenu bluetooth_ON)
#							 -> Bluetooth Hardware OFF (calls openbox-functions.sh togglemenu bluetooth_OFF)
#							 -> Bluetooth Applet ON (calls openbox-functions.sh togglemenu bluetoothapp_ON)
#							 -> Bluetooth Applet OFF (calls openbox-functions.sh togglemenu bluetoothapp_On)
#							 -> USB Host ON (calls openbox-functions.sh togglemenu usbhost_ON)
#							 -> USB Host OFF (calls openbox-functions.sh togglemenu usbhost_ON)
# Pandora Settings -> (displays output provided by openbox-functions.sh settingsmenu)
# GUI Config ->  (displays output provided by openbox-functions.sh configmenu)
#						 -> Reload Warlock Bar (calls openbox-functions.sh configmenu reloadwbar)
#						 -> Openbox (displays output provided by openbox-functions.sh configmenu openbox)
#						 -> Openbox -> Save / Load Keybindings (displays output provided by
#																					openbox-functions.sh configmenu openbox keybindings)
#						 -> Openbox -> Restart (calls openbox-functions.sh configmenu openbox restart)
# Toggle Tint2 Panel (calls openbox-functions.sh toggletint2)
# Toggle Warlock Bar (calls openbox-functions.sh togglewbar)
# Connectivity -> (displays output provided by openbox-functions.sh togglemenu)
# Power Off -> (displays output provided by openbox-functions.sh shutdownmenu)
#					  -> Shutdown (calls openbox-functions.sh shutdownmenu shutdown)
#					  -> Restart (calls openbox-functions.sh shutdownmenu restart)
#						-> Suspend (calls openbox-functions.sh shutdownmenu suspend)

# ----------------------------------------------------------------------------------


#	This function is called when "Web Browser" or "PND Installer" is chosen from the Root Menu.
# It loads the first entry available from XDG_CONFIG_HOME/openbox/webbrowser 
# or XDG_CONFIG_HOME/openbox/pndinstaller (as determined by its argument)

function loadprog
{
	# load same choice as we found last time	
	if [ -f $XDG_CACHE_HOME/$1.sh ]
	then
		bash $XDG_CACHE_HOME/$1.sh
		# $? is 1 if program no longer present (e.g. if SD card removed)		
		if [ $? -ne 1 ]
		then
			exit
		fi
	fi

	while read line
	do
		# ignore comments		
		if [[ "$line" =~ ^#.*$ ]]
		then
			continue
		fi		

		prog=$(grep -m 1 "^Exec" /usr/share/applications/$line.desktop 2> /dev/null)
		if [ ! "$prog" ]
		then
			prog=$(grep -m 1 "^Exec" $HOME/Desktop/$line#0.desktop 2> /dev/null)
		fi

		if [ "$prog" ]
		then 
			echo ${prog:5} | cut -d"%" -f1 > $XDG_CACHE_HOME/$1.sh
			chmod +x $XDG_CACHE_HOME/$1.sh
			exec $XDG_CACHE_HOME/$1.sh
		fi
	done < 	$XDG_CONFIG_HOME/openbox/$1
}


#	This function is called when "Connectivity" is chosen from the Root Menu.
# It dynamically creates a pipe menu for toggling wifi / bluetooth / usbhost ON or OFF.
# Entries from the pipe menu will call this function again, with 1 of the arguments:
# wifi_ON, wifi_OFF, networkapp_ON, networkapp_OFF,
# bluetooth_ON, bluetooth_OFF, bluetoothapp_ON, bluetoothapp_OFF,
# usbhost_ON, usbhost_OFF 

function togglemenu
{
	if [ "$1" == "" ]
	then	
		# whether the wifi hardware is on or off.
		# if we toggled using this menu last time, its state will be saved in	$XDG_CACHE_HOME/wifi
		if [ -f $XDG_CACHE_HOME/wifi ]
		then
			wifistate=$(cat $XDG_CACHE_HOME/wifi )
		else
			if [ "`lsmod | grep wl1251`" ]
			then
				wifistate="OFF"
			else
				wifistate="ON"
			fi
		fi

		# whether the wifi taskbar applet is running or not.
		if [ $(pidof nm-applet) ]
		then
			nmappletstate="OFF"
		else
			nmappletstate="ON" 
		fi

		# whether the bluetooth hardware is on or off.
		# TODO

		# whether the bluetooth taskbar applet is running or not.
		# TODO	

		# whether the usbhost hardware is on or off.
		# if we toggled using this menu last time, its state will be saved in	$XDG_CACHE_HOME/usb	
		if [ -f $XDG_CACHE_HOME/usb ]
		then
			usbstate=$(cat $XDG_CACHE_HOME/usb )
		else
			if [ "`lsmod | grep ehci_hcd`" ]
			then
				usbstate="OFF"
			else
				usbstate="ON"
			fi
		fi

		# output pipe menu	
		echo "<openbox_pipe_menu>"
		echo "<item label=\"Switch WiFi Hardware $wifistate\" icon=\"/usr/share/icons/openbox/wifi-hardware.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh togglemenu wifi_$wifistate</command>"
			echo "</action>"
		echo "</item>"
		echo "<item label=\"Switch WiFi Applet $nmappletstate\" icon=\"/usr/share/icons/openbox/wifi-applet.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>/usr/pandora/scripts/openbox-functions.sh togglemenu networkapp_$nmappletstate</command>"
			echo "</action>"
		echo "</item>"
		echo "<item label=\"Edit Network Connections\" icon=\"/usr/share/icons/openbox/edit-connections.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>nm-connection-editor</command>"
		echo "</action>"
		echo "</item>"
		echo "<separator />"
		echo "<item label=\"Bluetooth Hardware [TODO]\">"
		echo "</item>"
		echo "<item label=\"Bluetooth Applet [TODO]\">"
		echo "</item>"
		echo "<separator />"
		echo "<item label=\"Switch USB Host $usbstate\" icon=\"/usr/share/icons/openbox/toggle-usb.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh togglemenu usbhost_$usbstate</command>"
			echo "</action>"
		echo "</item>"
		echo "</openbox_pipe_menu>"
	
	else	
		# Process arguments
		case $1 in
			# "WiFi Hardware ON"	
			wifi_ON)
				user=$(cat /tmp/currentuser)		
				su -c 'notify-send -u normal "WLAN" "WLAN is being enabled..." -i /usr/share/icons/openbox/wifi-hardware.png' - $user
			
				/etc/init.d/wl1251-init start
			
				echo -n "OFF" > /tmp/obcache/wifi		
				;;

			# "WiFi Hardware OFF"
			wifi_OFF)
				user=$(cat /tmp/currentuser)		
				su -c 'notify-send -u normal "WLAN" "WLAN is being disabled..." -i /usr/share/icons/openbox/wifi-hardware.png' - $user
			
				/etc/init.d/wl1251-init stop
	
				echo -n "ON" > /tmp/obcache/wifi
				;;
	
			# "WiFi Applet ON"	
			networkapp_ON)
				if [ ! $(pidof tint2) ]
				then
					tint2 -c $XDG_CONFIG_HOME/tint2/tint2rc &
		 		fi
			
				nm-applet &> /dev/null &
				;;

			# "WiFi Applet OFF"
			networkapp_OFF)
				killall -9 nm-applet
				;;

			# "Bluetooth Hardware ON"	
			bluetooth_ON)
				# TODO
				;;

			# "Bluetooth Hardware OFF"	
			bluetooth_OFF)
			# TODO		
				;;

			# "Bluetooth Applet ON"	
			bluetoothapp_ON)
				# TODO
				;;
	
			# "Bluetooth Applet OFF"	
			bluetoothapp_OFF)
				# TODO
				;;

			# "USB Host ON"	
			usbhost_ON)
				user=$(cat /tmp/currentuser)		
				su -c 'notify-send -u normal "USB" "USB Host is being enabled..." -i /usr/share/icons/openbox/toggle-usb.png' - $user		

				modprobe ehci-hcd
		
				echo -n "OFF" > /tmp/obcache/usb
				;;

			# "USB Host OFF"		
			usbhost_OFF)
				user=$(cat /tmp/currentuser)		
				su -c 'notify-send -u normal "USB" "USB Host is being disabled..." -i /usr/share/icons/openbox/toggle-usb.png' - $user
		
				rmmod ehci-hcd
	
				echo -n "ON" > /tmp/obcache/usb
		 		;;
		esac
	fi
}


#	This function is called when "Pandora Settings" is chosen from the Root Menu.
# It dynamically creates a pipe menu for Pandora-specific config

function settingsmenu
{
	echo "<openbox_pipe_menu>"
	echo "<item label=\"CPU Settings\" icon=\"/tmp/iconcache/op_cpusettings.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/op_cpusettings.sh</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Calibrate Touchscreen\" icon=\"/tmp/iconcache/op_calibrate.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/op_calibrate.sh</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Date and Time\" icon=\"/tmp/iconcache/op_datetime.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/op_datetime.sh</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"LCD Settings\" icon=\"/tmp/iconcache/op_lcdsettings.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/op_lcdsettings.sh</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"LED Settings\" icon=\"/tmp/iconcache/op_ledsettings.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/op_ledsettings.sh</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Lid Close Settings\" icon=\"/tmp/iconcache/op_lidsettings.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/op_lidsettings.sh</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Nub Configurator\" icon=\"/tmp/iconcache/nubconfigurator.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/op_nubmode.py</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"SD Card Storage Mode\" icon=\"/tmp/iconcache/op_storage.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/op_storage.sh</command>"
		echo "</action>"
	echo "</item>"	
	echo "<item label=\"Startup\" icon=\"/tmp/iconcache/op_startupmanager.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>gksudo /usr/pandora/scripts/op_startupmanager.sh</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"TV Out Settings\" icon=\"/tmp/iconcache/op_tvout.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/TVoutConfig.py</command>"
		echo "</action>"
	echo "</item>"
	echo "</openbox_pipe_menu>"
}

#	This function is called when "GUI Config" is chosen from the Root Menu.
# It dynamically creates a pipe menu for Openbox / Tint2 / Wbar config
# Entries from the pipe menu will call this function again, with 1 of the arguments:
# "reloadwbar" (re-examine $HOME/Desktop, and show Warlock Bar with new contents), 
# "openbox" (show Openbox submenu),
# "openbox restart" (reload openbox), 
# "openbox keybindings" (Save or Load Openbox keybindings) 

function configmenu
{
	if [ "$1" == "" ]
	then	
		echo "<openbox_pipe_menu>"
		
		echo "<menu id=\"openboxconfig\" label=\"Openbox\" icon=\"/usr/share/pixmaps/openbox.png\" execute=\"/usr/pandora/scripts/openbox-functions.sh configmenu openbox\" />"		

		echo "<separator />"
		
		echo "<item label=\"GTK2 Theme Switcher\" icon=\"/usr/share/icons/openbox/gtk-theme-switch.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>gtk-chtheme</command>"
			echo "</action>"
		echo "</item>"

		echo "<separator />"

		echo "<item label=\"Tint2 Panel Wizard\" icon=\"/usr/share/icons/openbox/tint2.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>python /usr/bin/tintwizard.py $XDG_CONFIG_HOME/tint2/tint2rc</command>"
			echo "</action>"
		echo "</item>"

		echo "<separator />"

		echo "<item label=\"Reload Warlock Bar\" icon=\"/usr/share/pixmaps/wbar/wbar.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>/usr/pandora/scripts/openbox-functions.sh configmenu reloadwbar</command>"
			echo "</action>"
		echo "</item>"

		echo "<item label=\"Edit wbar-custom.cfg\" icon=\"/usr/share/icons/openbox/text-editor.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>mousepad $XDG_CONFIG_HOME/openbox/wbar_custom.cfg</command>"
			echo "</action>"
		echo "</item>"

		echo "<separator />"

		echo "<item label=\"Set Background [TODO]\" icon=\"/usr/share/icons/openbox/set-background.png\">"
	
		nitrogen=$(grep "^Exec" /usr/share/applications/nitrogen#0.desktop)
		if [ "$nitrogen" ]
		then
			echo "<action name=\"Execute\">"
					echo "<command>${nitrogen:5}</command>"
			echo "</action>"
		else
			echo "<action name=\"Execute\">"
				echo "<command>zenity --info --text=\"Please download the Nitrogen PND from the repo\"</command>"
			echo "</action>"		
		fi

		echo "</item>"

		echo "<separator />"
	
		echo "<item label=\"Choose Web Browser\" icon=\"/usr/share/icons/openbox/text-editor.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>mousepad $XDG_CONFIG_HOME/openbox/webbrowser</command>"
			echo "</action>"
		echo "</item>"

		echo "<item label=\"Choose PND Installer\" icon=\"/usr/share/icons/openbox/text-editor.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>mousepad $XDG_CONFIG_HOME/openbox/pndinstaller</command>"
			echo "</action>"
		echo "</item>"
	
		echo "</openbox_pipe_menu>"

	elif [ "$1" == "reloadwbar" ]
	then
		cat $XDG_CONFIG_HOME/openbox/wbar_custom.cfg > $XDG_CACHE_HOME/wbar.cfg

		for i in $HOME/Desktop/*.desktop
		do
			icon=$(grep -m 1 "^Icon=" "$i")
			if [ ${icon:5:1} = '/' ]							# absolute icon paths only
			then
				echo "i: ${icon:5}" >> $XDG_CACHE_HOME/wbar.cfg
			
				command=$(grep -m 1 "^Exec=" "$i")
				echo "c: ${command:5}" >> $XDG_CACHE_HOME/wbar.cfg
			
				text=$(grep -m 1 "^Name=" "$i")
				echo "t: ${text:5}" >> $XDG_CACHE_HOME/wbar.cfg
	
				echo "" >> $XDG_CACHE_HOME/wbar.cfg
			fi
		done

		if [ $(pidof wbar) ]
		then
			killall wbar
			wbar --config $XDG_CACHE_HOME/wbar.cfg &	
		fi
	
	elif [ "$1" == "openbox" ]
	then
		echo "<openbox_pipe_menu>"
	
		echo "<item label=\"Config Manager\" icon=\"/usr/share/pixmaps/obconf.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>obconf</command>"
			echo "</action>"
		echo "</item>"
	
		echo "<item label=\"Edit menu.xml\" icon=\"/usr/share/icons/openbox/text-editor.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>mousepad $XDG_CONFIG_HOME/openbox/menu.xml</command>"
			echo "</action>"
		echo "</item>"
	
		echo "<item label=\"Edit rc.xml\" icon=\"/usr/share/icons/openbox/text-editor.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>mousepad $XDG_CONFIG_HOME/openbox/rc.xml</command>"
			echo "</action>"
		echo "</item>"
	
		echo "<item label=\"Edit environment\" icon=\"/usr/share/icons/openbox/text-editor.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>mousepad $XDG_CONFIG_HOME/openbox/environment</command>"
			echo "</action>"
		echo "</item>"
	
		echo "<item label=\"Edit autostart\" icon=\"/usr/share/icons/openbox/text-editor.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>mousepad $XDG_CONFIG_HOME/openbox/autostart</command>"
			echo "</action>"
		echo "</item>"

		echo "<item label=\"Save / Load Keybindings\" icon=\"/usr/share/pixmaps/openbox.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>/usr/pandora/scripts/openbox-functions.sh configmenu openbox keybindings</command>"
			echo "</action>"
		echo "</item>"
	
		echo "<item label=\"Reconfigure\" icon=\"/usr/share/pixmaps/openbox.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>openbox --reconfigure</command>"
			echo "</action>"
		echo "</item>"
	
		echo "<item label=\"Restart\" icon=\"/usr/share/pixmaps/openbox.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>/usr/pandora/scripts/openbox-functions.sh configmenu openbox restart</command>"
			echo "</action>"
		echo "</item>"
	
		echo "</openbox_pipe_menu>"

		if [ "$2" == restart ]
		then
			echo "openbox-pandora-session" > /tmp/gui.load		
			/tmp/gui.stop
		fi	

		if [ "$2" == "keybindings" ]
		then
			saveload=$(zenity --list --width=400 --height=200 --title="Save / Load" --text "Choose whether to save your current keybindings or load a new set" --radiolist --column "Select" --column "Choice" TRUE "Save my current keybindings to a file" FALSE "Load new keybindings from a file")
			if [ "$saveload" == "Save my current keybindings to a file" ]
			then
				cd $XDG_CONFIG_HOME/openbox/keybindings
				savefile=$(zenity --file-selection --save --confirm-overwrite --title="Type any name")		
				if [ "$savefile" == "" ]
				then
					exit
				fi
				startprinting=0
				old_ifs=$IFS
	 			IFS=$'\n'	
				while read line
				do 
					if [[ "$line" =~ "<keyboard>" ]]
					then 
						startprinting=1
					fi
					if [ $startprinting == 1 ]
					then
				 		echo $line >> $savefile
			 		fi
					if [[ "$line" =~ "</keyboard>" ]]
					then 
						startprinting=0
					fi
				done < $XDG_CONFIG_HOME/openbox/rc.xml
				IFS=$old_ifs		
			fi

			if [ "$saveload" == "Load new keybindings from a file" ]
			then
				loadfile=$(zenity --file-selection --title="Choose a file" --filename="$XDG_CONFIG_HOME/openbox/keybindings/")

				if [ "$loadfile" == "" ]
				then
					exit
				fi
				startprinting=1
				old_ifs=$IFS
	 			IFS=$'\n'	
				while read line
				do 
					if [[ "$line" =~ "<keyboard>" ]]
					then 
						startprinting=0
					fi
					if [ $startprinting == 1 ]
					then
			 			echo $line >> /tmp/rc.xml
					fi
				done < $XDG_CONFIG_HOME/openbox/rc.xml
				startprinting=0
				while read line
				do 
					if [[ "$line" =~ "<keyboard>" ]]
					then 
						startprinting=1
					fi
					if [ $startprinting == 1 ]
					then
						echo $line >> /tmp/rc.xml
					fi
					if [[ "$line" =~ "</keyboard>" ]]
					then 
						startprinting=1
					fi
				done < $loadfile
				startprinting=0
				while read line
				do 
					if [ $startprinting == 1 ]
					then
						echo $line >> /tmp/rc.xml
					fi
					if [[ "$line" =~ "</keyboard>" ]]
					then 
						startprinting=1
					fi
				done < $XDG_CONFIG_HOME/openbox/rc.xml
				IFS=$old_ifs
				mv /tmp/rc.xml $XDG_CONFIG_HOME/openbox/rc.xml
				openbox --reconfigure
			fi
		fi
	fi
}

#	This function is called when "Power Off" is chosen from the Root Menu.
# It dynamically creates a pipe menu for Shutdown / Restart / Suspend / Log Off
# Entries from the pipe menu will call this function again, with 1 of the arguments:
# "shutdown"
# "restart"
# "suspend" 

function shutdownmenu
{
	if [ "$1" == "" ]
	then
		echo "<openbox_pipe_menu>"
		echo "<item label=\"Shutdown\" icon=\"/usr/share/icons/openbox/shutdown.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh shutdownmenu shutdown</command>"
			echo "</action>"
		echo "</item>"
		echo "<item label=\"Restart\" icon=\"/usr/share/icons/openbox/restart.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh shutdownmenu restart</command>"
			echo "</action>"
		echo "</item>"
		echo "<item label=\"Suspend\" icon=\"/usr/share/icons/openbox/suspend.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh shutdownmenu suspend</command>"
			echo "</action>"
		echo "</item>"
		echo "<item label=\"Logout\" icon=\"/usr/share/icons/openbox/logout.png\">"
			echo "<action name=\"Exit\">"
				echo "<prompt>yes</prompt>"
			echo "</action>"
		echo "</item>"
		echo "</openbox_pipe_menu>"
	
	else

		case $1 in	
			shutdown)
				if ! grep DEFAULT_SESSION=openbox-pandora-session $HOME/.xinitrc &> /dev/null
				then
					cp $HOME/.gtkrc-2.0_xfwm4 $HOME/.gtkrc-2.0
				fi
				shutdown -h now
				;;
			restart)
				if ! grep DEFAULT_SESSION=openbox-pandora-session $HOME/.xinitrc &> /dev/null
				then
					cp $HOME/.gtkrc-2.0_xfwm4 $HOME/.gtkrc-2.0
				fi
				shutdown -r now
				;;
			suspend)
				rm -f /tmp/obcache/wifi /tmp/obcache/bluetooth
				# pretend the power switch has been held for 1 second
				/usr/pandora/scripts/op_power.sh 1
				;;
		esac

	fi

}


# Process selections made from the Root Menu 

case $1 in
	# "Web Browser" or "PND Installer"	
	loadprog)
		loadprog $2;;
	
	# "Connectivity"
	togglemenu)
		togglemenu $2;;

	# "Pandora Settings"
	settingsmenu)
		settingsmenu;;

	# "GUI Config"
	configmenu)
		configmenu $2 $3;;

	# "Toggle Tint2 Panel"	
	toggletint2)
		if [ $(pidof tint2) ]
		then
			killall tint2
		else
			tint2 -c $XDG_CONFIG_HOME/tint2/tint2rc &
		fi		
		;;
	
	# "Toggle Warlock Bar"	
	togglewbar)
		if [ $(pidof wbar) ]
		then
			killall wbar
		else
			wbar --config $XDG_CACHE_HOME/wbar.cfg &
		fi		
		;;
	
	# "Power Off"
	shutdownmenu)
		shutdownmenu $2
		;;
esac




