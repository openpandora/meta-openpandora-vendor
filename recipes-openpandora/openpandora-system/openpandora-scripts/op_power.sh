#!/bin/bash

. /usr/pandora/scripts/op_paths.sh

# XXX: better use lockfile (or something), but it's not in current firmware
test -e /tmp/op_power.lock && exit 2
touch /tmp/op_power.lock
highpow="$(cat /etc/pandora/conf/led.conf | grep HighPowerLED: | awk -F\: '{print $2}')"
lowpow="$(cat /etc/pandora/conf/led.conf | grep LowPowerLED: | awk -F\: '{print $2}')"

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

	# only bother restoring brightness if it's 0
	# (old kernel or user messed it up somehow)
	brightness=$(cat $SYSFS_BACKLIGHT_BRIGHTNESS)
	if [ $brightness -gt 0 ]; then
		return 0
	fi

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
	kernel_major=`uname -r | cut -c 1`
	if [ "$kernel_major" = "2" ]; then
		echo 0 > $SYSFS_BACKLIGHT_BRIGHTNESS
	fi

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
	/usr/pandora/scripts/op_cpuspeed.sh -n 125
}

lowPowerOff(){ # switch from lowpower to normal mode
	oldspeed=$(cat /tmp/oldspeed)
	/usr/pandora/scripts/op_cpuspeed.sh -n $oldspeed
	rm -f /tmp/oldspeed

	display_on
	resume_net

	pidlist=$(pstree -lpA | grep pnd_run.sh | sed -ne 's/.*(\([0-9]\+\))/\1/p')
	for PID in $pidlist
	do
		kill -CONT $PID
	done
	echo $highpow > /sys/class/leds/pandora\:\:power/brightness #power LED bright
}

display_on_with_checks() {
	# after turning on the display, we don't want lowpower state
	# (which could be active because of some races)
	if [ "$powerstate" = "buttonlowpower" -o "$powerstate" = "lidlowpower" -o \
	     -e /tmp/oldspeed ]
	then
		lowPowerOff
	else
		display_on
	fi
}

show_message() {
	# TODO: check if desktop is visible; maybe use layer3?
	xfceuser=$(ps u -C xfce4-session | tail -n1 | awk '{print $1}')
	cmd="DISPLAY=:0.0 zenity --info --text \"$1\" --timeout 10"
	su -c "$cmd" $xfceuser
}

suspend_real() {
	delay=0

	if ! [ -e /sys/power/state ]; then
		# no kernel suspend support
		return 1
	fi

	current_now="$(cat /sys/class/power_supply/bq27500-0/current_now)"
 
	if [ $current_now -gt 0 ]; then 
		return 1 
		#don't suspend while unit is charging
	fi

	# can't suspend while SGX is in use due to bugs
	# (prevents low power states and potential lockup)
	if lsof -t /dev/pvrsrvkm > /dev/null; then
		return 1
	fi

	if ! grep -q 'mmc_core.removable=0' /proc/cmdline; then
		# must unmount cards because they will be "ejected" on suspend
		# (some filesystems may even deadlock if we don't do this due to bugs)
		mounts="$(grep "/dev/mmcblk" /proc/mounts | awk '{print $1}' | xargs echo)"
		for mnt in $mounts; do
			if ! umount $mnt; then
				show_message "Could not unmount $mnt, using partial suspend only"
				return 1
			fi
		done
		swaps="$(grep "/dev/mmcblk" /proc/swaps | awk '{print $1}' | xargs echo)"
		for swp in $swaps; do
			if ! swapoff $swp; then
				show_message "Could not unmount $swp, using partial suspend only"
				return 1
			fi
		done
	else
		if [ ! -e /etc/pandora/suspend-warned ]; then
			show_message "Pandora will now suspend.\n\n\
Please do not remove SD cards while pandora is suspended, doing so will corrupt them."
			touch /etc/pandora/suspend-warned
		fi
	fi

	# FIXME: fix the kernel and get rid of this
	suspend_net

	# get rid of modules that prevent suspend due to bugs
	modules="$(lsmod | awk '{print $1}' | xargs echo)"
	blacklist="g_zero g_audio g_ether g_serial g_midi gadgetfs g_file_storage
		g_mass_storage g_printer g_cdc g_multi g_hid g_dbgp g_nokia g_webcam g_ncm g_acm_ms
		ehci_hcd bridgedriver"
	restore_list=""
	for mod in $modules; do
		if echo $blacklist | grep -q "\<$mod\>"; then
			restore_list="$restore_list $mod"
			rmmod $mod
			delay=1 # enough?
		fi
	done

	sleep $delay
	sync
	echo mem > /sys/power/state

	# if we are here, either we already resumed or the suspend failed
	if [ -n "$restore_list" ]; then
		for module in $restore_list; do
			modprobe $module
		done
	fi

	display_on
	resume_net
	echo $highpow > /sys/class/leds/pandora\:\:power/brightness

	# wait here a bit to prevent this script from running again (keep op_power.lock)
	# in case user did resume using the power switch.
	sleep 2

	return 0
}

suspend_() {
	# dim power LED
	echo $lowpow > /sys/class/leds/pandora\:\:power/brightness

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
		elif [[ "$powerstate" == "liddisplayoff" ]]; then
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
					(debug && echo "display_on") || display_on_with_checks
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
elif [[ "$2" == "screensaver" ]]; then
	# warning: don't try to interact with X or do real suspend here -
	# will cause various deadlocks
	unset DISPLAY

	if [[ "$1" == 0 ]]; then # deactivate screensaver
		display_on_with_checks
		powerstate="on"
	elif [[ "$1" == 1 ]]; then # activate screensaver
		display_off
	fi
fi

debug && echo "powerstate=$powerstate"
echo "$powerstate" > /tmp/powerstate

rm -f /tmp/op_power.lock
