#!/bin/bash

. /usr/pandora/scripts/op_paths.sh

# XXX: better use lockfile (or something), but it's not in current firmware
test -e /tmp/op_power.lock && exit 2
touch /tmp/op_power.lock

debug(){
	return 1 # 0 when debugging, 1 when not
}

test -e $(grep /etc/passwd -e $(ps u -C xfce4-session | tail -n1 | awk '{print $1}')| cut -f 6 -d ":")/.lidconfig && lidconfig=$(cat $(grep /etc/passwd -e $(ps u -C xfce4-session | tail -n1 | awk '{print $1}')| cut -f 6 -d ":")/.lidconfig) # read lid conf. file if it exists

#powerbuttonconfig=$(cat $(grep /etc/passwd -e $(ps u -C xfce4-session | tail -n1 | awk '{print $1}')| cut -f 6 -d ":")/.powerbuttonconfig)

if [ -e /tmp/powerstate ]; then 
	powerstate="$(cat /tmp/powerstate)"
else
	powerstate="on"
fi

debug && echo "powerstate=$powerstate"

suspend_net() {
	hcistate=$(hciconfig hci0 | grep DOWN)
	if [ $hcistate ]; then
		echo "down" > /tmp/hcistate
	else
		echo "up" > /tmp/hcistate
		hciconfig hci0 down
	fi
	wlstate=$(lsmod | grep -m1 wl1251)
	if [ -z "$wlstate" ]; then
		echo "down" > /tmp/wlstate
	else
		echo "up" > /tmp/wlstate
		ifconfig wlan0 down
		rmmod board_omap3pandora_wifi 2> /dev/null
		rmmod wl1251_sdio wl1251
	fi
}

resume_net() {
	hcistate=$(cat /tmp/hcistate)
	if [ "$hcistate" = "up" ]; then
		hciconfig hci0 up pscan
	fi
	wlstate=$(cat /tmp/wlstate)
	if [ "$wlstate" = "up" ]; then
		/etc/init.d/wl1251-init start
	fi
	rm -f /tmp/hcistate /tmp/wlstate
}

display_on() {
	echo 0 > /sys/class/graphics/fb0/blank

	maxbright=$(cat $SYSFS_BACKLIGHT/max_brightness)
	oldbright=0
	if [ -f /tmp/oldbright ]; then
		oldbright=$(cat /tmp/oldbright)
	fi
	if [ $oldbright -eq 0 ]; then
		oldbright=$(cat /etc/pandora/conf/brightness.state)
	fi
	if [ $oldbright -ge 3 ] && [ $oldbright -le $maxbright ]; then 
		/usr/pandora/scripts/op_bright.sh $oldbright 
	else
		/usr/pandora/scripts/op_bright.sh $maxbright
	fi
}

display_off() {
	brightness=$(cat $SYSFS_BACKLIGHT_BRIGHTNESS)
	if [ $brightness -gt 0 ]; then
		echo $brightness > /tmp/oldbright
	fi
	echo 0 > $SYSFS_BACKLIGHT_BRIGHTNESS

	echo 1 > /sys/class/graphics/fb0/blank
}

lowPowerOn(){ #switch from normal to lowpower mode
	display_off

	pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
	for PID in $pidlist
	do
		kill -STOP $PID
	done

	suspend_net

	cat /proc/pandora/cpu_mhz_max > /tmp/oldspeed
	/usr/pandora/scripts/op_cpuspeed.sh 125
}

lowPowerOff(){ # switch from lowpower to normal mode
	oldspeed=$(cat /tmp/oldspeed)
	/usr/pandora/scripts/op_cpuspeed.sh $oldspeed

	display_on
	resume_net

	pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
	for PID in $pidlist
	do
		kill -CONT $PID
	done
	echo 255 > /sys/class/leds/pandora\:\:power/brightness #power LED bright
}

suspend_real() {
	delay=0

	if ! [ -e /sys/power/state ]; then
		# no kernel suspend support
		return 1
	fi

	# can't suspend while SGX is in use due to bugs
	# (prevents low power states and potential lockup)
	if lsof -t /dev/pvrsrvkm > /dev/null; then
		return 1
	fi

	# TODO: we probably want to NOT do real suspend if:
	# - cards don't unmount (running PNDs will break)
	# - while charging too, since it stops on suspend?

	# FIXME: fix the kernel and get rid of this
	suspend_net

	# get rid of modules that prevent suspend due to bugs
	modules="$(lsmod | awk '{print $1}' | xargs echo)"
	blacklist="ehci_hcd g_zero g_audio g_ether g_serial g_midi gadgetfs g_file_storage
		g_mass_storage g_printer g_cdc g_multi g_hid g_dbgp g_nokia g_webcam g_ncm g_acm_ms"
	restore_list=""
	for mod in $modules; do
		if echo $blacklist | grep -q "\<$mod\>"; then
			restore_list="$restore_list $mod"
			rmmod $mod
			delay=1 # enough?
		fi
	done

	# must unmount cards because they will be "ejected" on suspend
	# (some filesystems may even deadlock if we don't do this due to bugs)
	grep "/dev/mmcblk" /proc/mounts | awk '{print $1}' | xargs umount -r

	sleep $delay
	echo mem > /sys/power/state

	# if we are here, either we already resumed or the suspend failed
	if [ -n "$restore_list" ]; then
		modprobe $restore_list
	fi

	resume_net
	echo 255 > /sys/class/leds/pandora\:\:power/brightness

	# wait here a bit to prevent this script from running again (keep op_power.lock)
	# in case user did resume using the power switch.
	sleep 2

	return 0
}

suspend_() {
	# dim power LED
	echo 16 > /sys/class/leds/pandora\:\:power/brightness

	if suspend_real; then
		# resumed already
		powerstate="on"
	else
		lowPowerOn
	fi
}

resume() {
	if [ "$powerstate" = "on" ]; then
		# nothing to do
		echo "resume called unexpectedly" >&2
	else
		lowPowerOff
	fi
}

shutdown(){ # warns the user and shuts the pandora down
	xfceuser=$(ps u -C xfce4-session | tail -n1 | awk '{print $1}')
	time=5
	countdown () {
		for i in $(seq $time); do
			precentage=$(echo $i $time | awk '{ printf("%f\n", $1/$2*100) }')
			echo $precentage
			echo "# Shutdown in $(($time-$i))"
			sleep 1
		done
	}
	countdown | su -c 'DISPLAY=:0.0 zenity --progress --auto-close --text "Shutdown in X" --title "Shutdown"' $xfceuser
	if [ $? -eq 0 ]; then
	/sbin/shutdown -h now
	else
	su -c 'DISPLAY=:0.0 zenity --error --text "Shutdown aborted!"' $xfceuser
	fi
}

if [[ "$2" == "" ]]; then
	if [[ "$1" -le 2 ]]; then # power button was pressed 1-2sec, "suspend"
		if [[ "$powerstate" == "buttonlowpower" ]]; then
			(debug && echo "resume") || resume
			powerstate="on"
		elif [[ "$powerstate" == "on" ]]; then
			powerstate="buttonlowpower"
			(debug && echo "suspend") || suspend_
		fi
	elif [[ "$1" -ge 3 ]]; then # power button was pressed 3 sec or longer, shutdown
		if [[ "$powerstate" == "on" ]]; then
			(debug && echo "shutdown") || shutdown
		fi
	fi
elif [[ "$2" == "lid" ]]; then
	if [[ "$1" == 0 ]]; then # lid was opened
		if [[ "$powerstate" == lid* ]]; then
			case "$lidconfig" in
				"lowpower")
					(debug && echo "resume") || resume
					powerstate="on"
				;;
				*)
					(debug && echo "display_on") || display_on
					powerstate="on"
				;;
			esac
		fi
	elif [[ "$1" == 1 ]]; then # lid was closed
		if [[ "$powerstate" == "on" ]]; then
			case "$lidconfig" in
				"shutdown")
					(debug && echo "shutdown") || shutdown
				;;
				"lowpower")
					powerstate="lidlowpower"
					(debug && echo "suspend") || suspend_
				;;
				*)
					(debug && echo "display_off") || display_off
					powerstate="liddisplayoff"
				;;
			esac
		fi
	fi
 fi
debug && echo "powerstate=$powerstate"
echo "$powerstate" > /tmp/powerstate

rm -f /tmp/op_power.lock
