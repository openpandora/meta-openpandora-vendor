#!/bin/bash
#
# author: freamon
# released under the GPL

function configmenu
{
	nitrogen=$(grep "^Exec" /usr/share/applications/nitrogen#0.desktop)

	echo "<openbox_pipe_menu>"
	if [ "$nitrogen" ]
	then
		echo "<item label=\"Set Background\" icon=\"/usr/share/icons/openbox/nitrogen.png\">"
			echo "<action name=\"Execute\">"
				echo "<command>${nitrogen:5}</command>"
			echo "</action>"
		echo "</item>"
	fi
	
	echo "<item label=\"Config Manager\" icon=\"/usr/share/pixmaps/obconf.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>obconf</command>"
		echo "</action>"
	echo "</item>"

	echo "<item label=\"GTK+ Theme Switcher\" icon=\"/usr/share/pixmaps/obconf.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>gtk-chtheme</command>"
		echo "</action>"
	echo "</item>"

	echo "<item label=\"Tint2 Panel Wizard\" icon=\"/usr/share/icons/gnome/48x48/actions/remove.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>python /usr/bin/tintwizard.py $XDG_CONFIG_HOME/tint2/tint2rc</command>"
		echo "</action>"
	echo "</item>"


	echo "<item label=\"Edit menu.xml\" icon=\"/usr/share/icons/gnome/48x48/apps/accessories-text-editor.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>mousepad $XDG_CONFIG_HOME/openbox/menu.xml</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Edit rc.xml\" icon=\"/usr/share/icons/gnome/48x48/apps/accessories-text-editor.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>mousepad $XDG_CONFIG_HOME/openbox/rc.xml</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Edit environment\" icon=\"/usr/share/icons/gnome/48x48/apps/accessories-text-editor.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>mousepad $XDG_CONFIG_HOME/openbox/environment</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Edit autostart\" icon=\"/usr/share/icons/gnome/48x48/apps/accessories-text-editor.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>mousepad $XDG_CONFIG_HOME/openbox/autostart</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Edit wbar-custom.cfg\" icon=\"/usr/share/icons/gnome/48x48/apps/accessories-text-editor.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>mousepad $XDG_CONFIG_HOME/openbox/wbar_custom.cfg</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Reload Warlock Bar\" icon=\"/usr/share/pixmaps/wbar/wbar.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/openbox-functions.sh reloadwbar</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Save / Load Keybindings\" icon=\"/usr/share/pixmaps/openbox.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/openbox-functions.sh keybindings</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Reconfigure\" icon=\"/usr/share/pixmaps/openbox.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>openbox --reconfigure</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Restart\" icon=\"/usr/share/pixmaps/openbox.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/openbox-functions.sh openbox_restart</command>"
		echo "</action>"
	echo "</item>"
	echo "</openbox_pipe_menu>"
}

function togglemenu
{
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

	if [ -f $XDG_CACHE_HOME/bluetooth ]
	then
		bluetoothstate=$(cat $XDG_CACHE_HOME/bluetooth )
	else
		INTERFACE="`hciconfig | grep "^hci" | cut -d ':' -f 1`"		

		if [ "$INTERFACE" != "" ]
		then		
			if hciconfig "$INTERFACE" | grep UP &>/dev/null
			then
				bluetoothstate="OFF"
			else
				bluetoothstate="ON"
			fi
		else
			bluetoothstate="ON"
		fi
	fi	

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

	if [ $(pidof nm-applet) ]
	then
		nmappletstate="OFF"
	else
		nmappletstate="ON" 
	fi

	if [ $(pidof bluetooth-applet) ]
	then
		bluetoothappletstate="OFF"
	else
		bluetoothappletstate="ON" 
	fi	

	echo "<openbox_pipe_menu>"
	echo "<item label=\"Switch WiFi Hardware $wifistate\" icon=\"/tmp/iconcache/op_wifi.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh wifi_$wifistate</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Switch WiFi Applet $nmappletstate\" icon=\"/usr/share/icons/hicolor/22x22/apps/nm-device-wwan.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/openbox-functions.sh networkapp_$nmappletstate</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Edit Network Connections\" icon=\"/usr/share/icons/gnome/32x32/status/network-idle.png\">"
	echo "<action name=\"Execute\">"
		echo "<command>nm-connection-editor</command>"
	echo "</action>"
	echo "</item>"
	echo "<separator />"
	echo "<item label=\"Switch Bluetooth Hardware $bluetoothstate\" icon=\"/usr/share/icons/hicolor/32x32/apps/bluetooth.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/openbox-functions.sh bluetooth_$bluetoothstate</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Switch Bluetooth Applet $bluetoothappletstate\" icon=\"/usr/share/icons/openbox/bluetooth_app.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>/usr/pandora/scripts/openbox-functions.sh bluetoothapp_$bluetoothappletstate</command>"
		echo "</action>"
	echo "</item>"
	echo "<separator />"
	echo "<item label=\"Switch USB Host $usbstate\" icon=\"/tmp/iconcache/op_usbhost.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh usbhost_$usbstate</command>"
		echo "</action>"
	echo "</item>"
	echo "</openbox_pipe_menu>"
}

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

function keybindings
{
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
}

function reloadwbar
{
	cat $XDG_CONFIG_HOME/openbox/wbar_custom.cfg > $XDG_CACHE_HOME/wbar.cfg

	for i in $HOME/Desktop/*.desktop
	do
		icon=$(grep "^Icon=" "$i")
		if [ ${icon:5:1} = '/' ]							# absolute icon paths only
		then
			echo "i: ${icon:5}" >> $XDG_CACHE_HOME/wbar.cfg
			
			command=$(grep "^Exec=" "$i")
			echo "c: ${command:5}" >> $XDG_CACHE_HOME/wbar.cfg
			
			text=$(grep "^Name=" "$i")
			echo "t: ${text:5}" >> $XDG_CACHE_HOME/wbar.cfg
	
			echo "" >> $XDG_CACHE_HOME/wbar.cfg
		fi
	done

	if [ $(pidof wbar) ]
	then
		killall wbar
		wbar --config $XDG_CACHE_HOME/wbar.cfg &	
	fi
}

function pndinstaller
{
	# load same pnd installer as we found last time	
	if [ -f $XDG_CACHE_HOME/pndinstaller.sh ]
	then
		bash $XDG_CACHE_HOME/pndinstaller.sh
		# $? is 1 if pnd installer no longer present (e.g. if SD card removed)		
		if [ $? -ne 1 ]
		then
			exit
		fi
	fi	

	pndmanager=$(grep "^Exec" /usr/share/applications/pndmanager#0.desktop)
	if [ ! "$pndmanager" ]
	then
		pndmanager=$(grep "^Exec" $HOME/Desktop/pndmanager#0.desktop)
	fi

	if [ "$pndmanager" ]
	then 
		echo ${pndmanager:5} > $XDG_CACHE_HOME/pndinstaller.sh
		chmod +x $XDG_CACHE_HOME/pndinstaller.sh
		exec $XDG_CACHE_HOME/pndinstaller.sh
	else
		exec python /usr/bin/PNDstore
	fi
}

function webbrowser
{
	# load same browser as we found last time	
	if [ -f $XDG_CACHE_HOME/webbrowser.sh ]
	then
		bash $XDG_CACHE_HOME/webbrowser.sh
		# $? is 1 if browser no longer present (e.g. if SD card removed)		
		if [ $? -ne 1 ]
		then
			exit
		fi
	fi

	# use XDG_CONFIG_HOME/openbox/webbrowser to load user's preffered webbrowser

	while read i
	do
		webbrowser=$(grep "^Exec" /usr/share/applications/$i#0.desktop 2> /dev/null)
		if [ ! "$webbrowser" ]
		then
			webbrowser=$(grep "^Exec" $HOME/Desktop/$i#0.desktop 2> /dev/null)
		fi

		if [ "$webbrowser" ]
		then 
			echo ${webbrowser:5} > $XDG_CACHE_HOME/webbrowser.sh
			chmod +x $XDG_CACHE_HOME/webbrowser.sh
			exec $XDG_CACHE_HOME/webbrowser.sh
		fi
	done < 	$XDG_CONFIG_HOME/openbox/webbrowser
}

function shutdownmenu
{
	echo "<openbox_pipe_menu>"
	echo "<item label=\"Shutdown\" icon=\"/usr/share/icons/hicolor/48x48/apps/xfsm-shutdown.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh shutdown</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Restart\" icon=\"/usr/share/icons/hicolor/48x48/apps/xfsm-reboot.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh restart</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Suspend\" icon=\"/usr/share/icons/hicolor/48x48/apps/xfsm-suspend.png\">"
		echo "<action name=\"Execute\">"
			echo "<command>sudo /usr/pandora/scripts/openbox-functions.sh suspend</command>"
		echo "</action>"
	echo "</item>"
	echo "<item label=\"Logout\" icon=\"/usr/share/icons/hicolor/48x48/apps/xfsm-logout.png\">"
		echo "<action name=\"Exit\">"
			echo "<prompt>yes</prompt>"
		echo "</action>"
	echo "</item>"
	echo "</openbox_pipe_menu>"
}

case $1 in
	networkapp_ON)
		if [ ! $(pidof tint2) ]
		then
			tint2 -c $XDG_CONFIG_HOME/tint2/tint2rc &
		fi
		
		nm-applet &> /dev/null &
		;;
	networkapp_OFF)
		killall nm-applet
		;;
	bluetoothapp_ON)
		if [ ! $(pidof tint2) ]
		then
			tint2 -c $XDG_CONFIG_HOME/tint2/tint2rc &
		fi
		
		bluetooth-applet &> /dev/null &
		;;
	bluetoothapp_OFF)
		killall bluetooth-applet
		;;
	toggletint2)
		if [ $(pidof tint2) ]
		then
			killall tint2
		else
			tint2 -c $XDG_CONFIG_HOME/tint2/tint2rc &
		fi		
		;;
	togglewbar)
		if [ $(pidof wbar) ]
		then
			killall wbar
		else
			wbar --config $XDG_CACHE_HOME/wbar.cfg &
		fi		
		;;
	configmenu)
		configmenu;;
	togglemenu)
		togglemenu;;
	wifi_ON)
		user=$(cat /tmp/currentuser)		
		su -c 'notify-send -u normal "WLAN" "WLAN is being enabled..." -i /usr/share/icons/hicolor/32x32/apps/nm-device-wired.png' - $user
		
		/etc/init.d/wl1251-init start
		
		echo -n "OFF" > /tmp/obcache/wifi		
		;;
	wifi_OFF)
		user=$(cat /tmp/currentuser)		
		su -c 'notify-send -u normal "WLAN" "WLAN is being disabled..." -i /usr/share/icons/hicolor/32x32/apps/nm-no-connection.png' - $user
		
		ifconfig wlan0 down
		rmmod wl1251_sdio wl1251

		echo -n "ON" > /tmp/obcache/wifi
		;;
	bluetooth_ON)
		/usr/pandora/scripts/op_bluetooth.sh

		echo -n "OFF" > /tmp/obcache/bluetooth
		;;
	bluetooth_OFF)
		/usr/pandora/scripts/op_bluetooth.sh

		echo -n "ON" > /tmp/obcache/bluetooth
		;;
	usbhost_ON)
		modprobe ehci-hcd
		
		echo -n "OFF" > /tmp/obcache/usb
		;;
	usbhost_OFF)
		rmmod ehci-hcd
	
		echo -n "ON" > /tmp/obcache/usb
		;;
	settingsmenu)
		settingsmenu;;
	keybindings)
		keybindings;;
	reloadwbar)
		reloadwbar;;
	openbox_restart)
		echo "openbox-pandora-session" > /tmp/gui.load		
		/tmp/gui.stop
		;;
	pndinstaller)
		pndinstaller;;
	webbrowser)
		webbrowser;;
	shutdownmenu)
		shutdownmenu;;
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




