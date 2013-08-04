#!/bin/sh

case "$1" in
	start)
		modprobe mailbox_mach
		modprobe bridgedriver base_img=/lib/dsp/baseimage.dof
		;;
	stop)
		rmmod bridgedriver
		rmmod mailbox_mach
		rmmod mailbox
		;;
	restart)
		rmmod bridgedriver
		rmmod mailbox_mach
		rmmod mailbox
		sleep 0.5
		modprobe mailbox_mach
		modprobe bridgedriver base_img=/lib/dsp/baseimage.dof
		;;
esac

