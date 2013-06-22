#!/bin/sh
#
# Called from udev
#
# Attempt to mount any added block devices and remove any removed devices.
#

MOUNT="/bin/mount"
PMOUNT="/usr/bin/pmount"
UMOUNT="/bin/umount"
blkid="/sbin/blkid"
name="`basename "$DEVNAME"`"
name2="`$blkid "$DEVNAME" -c /dev/null -o value -s LABEL | sed 's/ /_/g'`"
name3=$(echo $DEVNAME | sed 's/.*dev.//g')
uid=$(cat /tmp/currentuid)

for line in `grep -v ^# /etc/udev/mount.blacklist`
do
	if ( echo "$DEVNAME" | grep -q "$line" )
	then
		logger "udev/mount.sh" "[$DEVNAME] is blacklisted, ignoring"
		exit 0
	fi
done

automount() {	
	if [ -n "$name2" ] 
	then
		c=1
		while ( grep "/media/$name2"  /proc/mounts); do
			name2="$name2-$c"
			c=$(expr $c + 1)
		done
		name="$name2"
	fi
	! test -d "/media/$name" && mkdir -p "/media/$name"
	
	
	if ! $MOUNT -t auto -o dirsync,noatime,umask=0 $DEVNAME "/media/$name" && ! $MOUNT -t auto -o dirsync,noatime $DEVNAME "/media/$name"
	then
		#logger "mount.sh/automount" "$MOUNT -t auto $DEVNAME \"/media/$name\" failed!"
		rm_dir "/media/$name"
	else
		logger "mount.sh/automount" "Auto-mount of [/media/$name] successful"
		touch "/tmp/.automount-$name3"
		fstype=$(cat /etc/mtab | grep $DEVNAME | awk  '{print $3}') 
		echo "$DEVNAME	$uid	0	$fstype	dirsync,noatime,umask=0	/media/$name" >> /media/.hal-mtab
		touch /media/.hal-mtab-lock
	fi
}
	
rm_dir() {
	# We do not want to rm -r populated directories
	if test "`find "$1" | wc -l | tr -d " "`" -lt 2 -a -d "$1"
	then
		! test -z "$1" && rm -r "$1"
	else
		logger "mount.sh/automount" "Not removing non-empty directory [$1]"
	fi
}

if [ "$ACTION" = "add" ] && [ -n "$DEVNAME" ]; then
	if [ -x "$PMOUNT" ]; then
		$PMOUNT $DEVNAME 2> /dev/null
	elif [ -x $MOUNT ]; then
    		$MOUNT $DEVNAME 2> /dev/null
	fi
	
	# If the device isn't mounted at this point, it isn't configured in fstab
	# 20061107: Small correction: The rootfs partition may be called just "rootfs" and not by
	# 	    its true device name so this would break. If the rootfs is mounted on two places
	#	    during boot, it confuses the heck out of fsck. So Im auto-adding the root-partition
	#	    to /etc/udev/mount.blacklist via postinst 

	cat /proc/mounts | awk '{print $1}' | grep -q "^$DEVNAME$" || automount 
	
fi

if [ "$ACTION" = "remove" ] && [ -x "$UMOUNT" ] && [ -n "$DEVNAME" ]; then
	for mnt in `grep "$DEVNAME" /proc/mounts | cut -f 2 -d " " `
	do
		# 20100306: Remove the mount point forcibly (Lazy) as the user has already removed the device by the 
		# DJWillis: time this fires so any handles are bad anyway. This should stop 'stale' folders being
		#           left around all the time. | cut -d ' ' -f 2 | sed 's/\\040/ /g'
		mnt2=$(echo $mnt | sed 's/\\040/ /g')
		$UMOUNT -l "$mnt2"
	done
	
	# Remove empty directories from auto-mounter
	sed -e "/$name3/d" /media/.hal-mtab > /tmp/.hal-mtab
	mv /tmp/.hal-mtab /media/.hal-mtab
	test -e "/tmp/.automount-$name3" && rm_dir "$mnt2"
fi
