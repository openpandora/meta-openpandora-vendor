#!/bin/bash
 
#Usage: pnd_run.sh -p your.pnd -e executeable [-a "(arguments)"] [ -s "cd to folder inside pnd"] [-b UID (name of mountpoint/pandora/appdata)] [-x close x before launching(script needs to be started with nohup for this to work]
# -s startdir
# arguments can be inside -e, -a is optional
 
#/etc/sudoers needs to be adjusted if you touch any of the sudo lines
 
# look at the comments in the nox part, adjust 
#use "lsof /usr/lib/libX11.so.6 | awk '{print $1}'| sort | uniq > whitelist" with nothing running to generate the whitelist
 
#todo - no proper order
#validate params better
#make uid/pnd_name mandatory (and rename var, its confusing!)
#find a clean way of shutting down x without a fixed dm, mabye avoid nohup usage somehow
#add options to just mount iso without union and to mount the union later
#cleanup
#Rewrite! - this sucks

list_using_fs() {
	for p in $(fuser -m $1 2>/dev/null);do ps hf $p;done
}

runApp() {
	unset CURRENTSPEED
	if ! [ -f "${MOUNTPOINT}/pandora/appdata/${PND_NAME}/cpuspeed" ]; then
		if [ ${cpuspeed:-$(cat /proc/pandora/cpu_mhz_max)} -gt $(cat /proc/pandora/cpu_mhz_max) ]; then 
        	   cpuselection=$(zenity --title="set cpu speed" --height=350 --list --column "id" --column "Please select" --hide-column=1 --text="$PND_NAME suggests to set the cpu speed to $cpuspeed MHz to make it run properly.\n\n Do you want to change the cpu speed? (current speed: $(cat /proc/pandora/cpu_mhz_max) MHz)\n\nWarning: Setting the clock speed above 600MHz can be unstable and it NOT recommended!" "yes" "Yes, set it to $cpuspeed MHz" "custom" "Yes, select custom value" "yessave" "Yes, set it to $cpuspeed MHz and don't ask again" "customsave" "Yes, set it to custom speed and don't ask again" "no" "No, don't change the speed" "nosave" "No, don't chage the speed and don't ask again")
		  if [ ${cpuselection} = "yes" ]; then	
			CURRENTSPEED=$(cat /proc/pandora/cpu_mhz_max)
			sudo /usr/pandora/scripts/op_cpuspeed.sh $cpuspeed
	  	  elif [ ${cpuselection} = "custom" ]; then	
			CURRENTSPEED=$(cat /proc/pandora/cpu_mhz_max)
			sudo /usr/pandora/scripts/op_cpuspeed.sh
		  elif [ ${cpuselection} = "customsave" ]; then	
			CURRENTSPEED=$(cat /proc/pandora/cpu_mhz_max)
			sudo /usr/pandora/scripts/op_cpuspeed.sh
			zenity --info --title="Note" --text="Speed saved.\n\nTo re-enable this dialogue, please delete the file\n${MOUNTPOINT}/pandora/appdata/${PND_NAME}/cpuspeed"
			cat /proc/pandora/cpu_mhz_max > ${MOUNTPOINT}/pandora/appdata/${PND_NAME}/cpuspeed
         	 elif [ ${cpuselection} = "yessave" ]; then	
			CURRENTSPEED=$(cat /proc/pandora/cpu_mhz_max)
			cat /proc/pandora/cpu_mhz_max > /tmp/cpuspeed		
			zenity --info --title="Note" --text="Speed saved.\n\nTo re-enable this dialogue, please delete the file\n${MOUNTPOINT}/pandora/appdata/${PND_NAME}/cpuspeed"
			sudo /usr/pandora/scripts/op_cpuspeed.sh $cpuspeed
			cat /proc/pandora/cpu_mhz_max > ${MOUNTPOINT}/pandora/appdata/${PND_NAME}/cpuspeed
                 elif [ ${cpuselection} = "nosave" ]; then			
			zenity --info --title="Note" --text="Speed will not be changed.\n\nTo re-enable this dialogue, please delete the file\n${MOUNTPOINT}/pandora/appdata/${PND_NAME}/cpuspeed"
			echo 9999 > ${MOUNTPOINT}/pandora/appdata/${PND_NAME}/cpuspeed
 	 	fi
	       fi
	else
		cpuspeed=$(cat "${MOUNTPOINT}/pandora/appdata/${PND_NAME}/cpuspeed")
		if [ "$cpuspeed" -lt "1500" ]; then
		  CURRENTSPEED=$(cat /proc/pandora/cpu_mhz_max)
		  echo Setting to CPU-Speed $cpuspeed MHz
		  sudo /usr/pandora/scripts/op_cpuspeed.sh $cpuspeed
		fi
        fi

	cd "/mnt/utmp/$PND_NAME"		# cd to union mount
	if [ "$STARTDIR" ] && [ -d "$STARTDIR" ]; then
		cd "$STARTDIR";			# cd to folder specified by the optional arg -s
	fi
	echo "[------------------------------]{ App start }[---------------------------------]"
	if [ -d /mnt/utmp/$PND_NAME/lib ];then
		export LD_LIBRARY_PATH="/mnt/utmp/$PND_NAME/lib:${LD_LIBRARY_PATH:-"/usr/lib:/lib"}"
	else
		export LD_LIBRARY_PATH="/mnt/utmp/$PND_NAME:${LD_LIBRARY_PATH:-"/usr/lib:/lib"}"
	fi
	if [ -d /mnt/utmp/$PND_NAME/bin ];then
		export PATH="/mnt/utmp/$PND_NAME/bin:${PATH:-"/usr/bin:/bin:/usr/local/bin"}"
	fi
	if [ -d /mnt/utmp/$PND_NAME/share ];then
	        export XDG_DATA_DIRS="/mnt/utmp/$PND_NAME/share:$XDG_DATA_DIRS:/usr/share"
	fi
	export XDG_CONFIG_HOME="/mnt/utmp/$PND_NAME"
	"./$EXENAME" $ARGUMENTS
						# execute app with ld_lib_path set to the union mount, a bit evil but i think its a good solution

	#the app could have exited now, OR it went into bg, we still need to wait in that case till it really quits!
	PID=$(pidof -o %PPID -x \"$EXENAME\")	# get pid of app
	while [ "$PID" ];do			# wait till we get no pid back for tha app, again a bit ugly, but it works
		sleep 10s
		PID=`pidof -o %PPID -x \"$EXENAME\"`
	done
	echo "[-------------------------------]{ App end }[----------------------------------]"

	if [ ! -z "$CURRENTSPEED" ]; then
		sudo /usr/pandora/scripts/op_cpuspeed.sh $CURRENTSPEED
	fi
}

mountPnd() {
	if [ $(id -u) -ne 0 ];then
		echo "sudo /usr/pandora/scripts/pnd_run.sh -m $PNDARGS"
		sudo /usr/pandora/scripts/pnd_run.sh -m $PNDARGS
		mount | grep "on /mnt/utmp/${PND_NAME} type"
		if [ $? -ne 0 ];then
			echo "The Union File-system is not mounted !"
			return 1
		fi
		return $?
	fi
	#create mountpoints, check if they exist already first to avoid annoying error messages
	if ! [ -d "/mnt/pnd/${PND_NAME}" ]; then 
		mkdir -p "/mnt/pnd/${PND_NAME}"		#mountpoint for iso, ro
	fi 
	#writeable dir for union
	if ! [ -d "${APPDATADIR}" ]; then 
		mkdir -p "${APPDATADIR}"
		chmod -R a+xrw "${APPDATADIR}" 2>/dev/null
	fi
	# create the union mountpoint
	if ! [ -d "/mnt/utmp/${PND_NAME}" ]; then
		mkdir -p "/mnt/utmp/${PND_NAME}"		# union over the two
	fi
	#is the union already mounted? if not mount evrything, else launch the stuff
	mount | grep "on /mnt/utmp/${PND_NAME} type"
	if [ $? -ne 0 ];then
		mount | grep "on /mnt/pnd/${PND_NAME} type"
		if [ $? -ne 0 ];then
			echo not mounted on loop yet, doing so
			#check if pnd is already attached to loop 
			LOOP=$(losetup -a | grep "$PND" | tail -n1 | awk -F: '{print $1}')
			#check if the loop device is already mounted
			if ! [ -z "$LOOP" ];then
				echo "Found a loop ($LOOP), using it"
				loopmountedon=$( mount | grep "$(mount | grep "$LOOP" | awk '{print $3}')" | grep utmp | awk '{print $3}' )
			else
				loopmountedon=""
			fi
			echo "LoopMountedon: $loopmountedon"
			if [ ! "$loopmountedon" ]; then #check if the pnd is already attached to some loop device but not used
				FREELOOP=$LOOP 
				#reuse existing loop
				if [ ! "$LOOP" ]; then
					FREELOOP=$(/sbin/losetup -f) #get first free loop device
					echo $FREELOOP
					if [ ! "$FREELOOP" ]; then  # no free loop device, create a new one
						    #find a free loop device and use it 
						    usedminor=$(/sbin/losetup -a | tail -n1)
						    usedminor=${usedminor:9:1}
						    echo usedminor $usedminor
						    freeminor=$(($usedminor+1))
						    echo freeminor $freeminor
						    mknod -m777 /dev/loop$freeminor b 7 $freeminor
						    FREELOOP=/dev/loop$freeminor
					fi
				fi
				#detect fs

				case $PND_FSTYPE in
				ISO)
					/sbin/losetup $FREELOOP "$PND" #attach the pnd to the loop device
					mntline="mount" #setup the mountline for later
					mntdev="${FREELOOP}"
					#mntline="mount -o loop,mode=777 $PND /mnt/pnd/$PND_NAME"
					echo "Filetype is $PND_FSTYPE";;
				directory)
					#we bind the folder, now it can be treated in a unified way 
					#ATENTION: -o ro doesnt work for --bind at least on 25, on 26 its possible using remount, may have changed on 27
					mntline="mount --bind -o ro"
					mntdev="${PND}"
					echo "Filetype is $PND_FSTYPE";;
				Squashfs)
					/sbin/losetup $FREELOOP "$PND" #attach the pnd to the loop device
					mntline="mount -t squashfs"
					mntdev="${FREELOOP}"
					echo "Filetype is $PND_FSTYPE";;
				*)
					echo "error determining fs, output was $PND_FSTYPE"
					exit 1;;
				esac
				echo "Mounting PND ($mntline) :"
				$mntline "$mntdev" "/mnt/pnd/${PND_NAME}" #mount the pnd/folder

			else #the pnd is already mounted but a mount was requested with a different basename/uid, just link it there
				      echo $LOOP already mounted on $loopmountedon skipping losetup - putting link to old mount
				      #this is bullshit
				      rmdir "/mnt/utmp/$PND_NAME"
				      ln -s $loopmountedon "/mnt/utmp/$PND_NAME" 
			fi

			mount | grep "on /mnt/pnd/${PND_NAME} type"
			if [ $? -ne 0 ];then
				echo "The PND File-system is not mounted ! - Union wont work anyway"
				return 2
			fi
		
		else
			echo "the PND is already mounted"
		fi
		FILESYSTEM=$(mount | grep "on $MOUNTPOINT " | grep -v rootfs | awk '{print $5}' | tail -n1) #get filesystem appdata is on to determine aufs options
		RO=0;for o in $(mount|grep "on $MOUNTPOINT "|sed 's/.*(//;s/)$//;s/,/ /g');do [[ $o = "ro" ]]&& RO=1;done
		if [ $RO -eq 1 ];then
			echo "SD-Card is mounted Read-only !! Trying to remount RW"
			mount -oremount,rw $MOUNTPOINT
		fi
		echo "Filesystem is $FILESYSTEM"
		echo "Mounting the Union FS using ${APPDATADIR} as Write directory:"
		if [[ "$FILESYSTEM" = "vfat" ]]; then # use noplink on fat, dont on other fs's 
			#append is fucking dirty, need to clean that up
			echo mount -t aufs -o exec,noplink,dirs="${APPDATADIR}=rw+nolwh":"/mnt/pnd/$PND_NAME=rr$append" none "/mnt/utmp/$PND_NAME"
			mount -t aufs -o exec,noplink,dirs="${APPDATADIR}=rw+nolwh":"/mnt/pnd/$PND_NAME=rr$append" none "/mnt/utmp/$PND_NAME"
			# put union on top
		else
			mount -t aufs -o exec,dirs="${APPDATADIR}=rw+nolwh":"/mnt/pnd/$PND_NAME=rr$append" none "/mnt/utmp/$PND_NAME" 
			# put union on top
		fi

		mount | grep "on /mnt/utmp/${PND_NAME} type"
		if [ $? -ne 0 ];then
			echo "The Union File-system is not mounted !"
			return 1
		fi
		
	else
		echo "Union already mounted"
	fi
}

cleanups() {
	#delete folders created by aufs if empty
	rmdir -rf "${APPDATADIR}/.wh..wh.plnk" 2>/dev/null
	rmdir -rf "${APPDATADIR}/.wh..wh..tmp" 2>/dev/null
	rmdir "${APPDATADIR}/.wh..wh.orph" 2>/dev/null
	rm "${APPDATADIR}/.aufs.xino" 2>/dev/null

	#delete appdata folder and ancestors if _empty_
	rmdir -p "${APPDATADIR}" 2>/dev/null

	# Clean the loopback device
	if [ $PND_FSTYPE = ISO ] || [ $PND_FSTYPE = Squashfs ]; then # check if we where running an iso, clean up loop device if we did
		LOOP=$(losetup -a | grep "$(basename $PND)" | tail -n1 | awk -F: '{print $1}')
		/sbin/losetup -d $LOOP
		rm $LOOP
	fi

	echo cleanup done
}

umountPnd() {
	if mount | grep -q "on /mnt/pnd/${PND_NAME} type";then
		umount "/mnt/pnd/$PND_NAME"
	fi
	if ! [ -z "$(mount |grep pnd/$PND_NAME|cut -f3 -d' ')" ]; then
		echo umount PND failed, didnt clean up. Process still using this FS :
		list_using_fs "/mnt/pnd/$PND_NAME"
	else
		# removing the now useless mountpoint
		if [ -d /mnt/pnd/$PND_NAME ];then
			rmdir "/mnt/pnd/$PND_NAME"
		fi

		# All went well, cleaning
		cleanups
	fi
}

umountUnion() {
	# Are we root yet ?
	if [ $(id -u) -ne 0 ];then
		sudo /usr/pandora/scripts/pnd_run.sh -u $PNDARGS
		return $?
	fi

	# Make sure the Union FS is unmounted
	if mount | grep -q "on /mnt/utmp/${PND_NAME} type";then
		umount "/mnt/utmp/$PND_NAME" #umount union
	fi
	if ! [ -z "$(mount |grep utmp/$PND_NAME|cut -f3 -d' ')" ]; then
		echo umount UNION failed, didnt clean up. Process still using this FS :
		list_using_fs "/mnt/utmp/$PND_NAME"
	else
		# the Union is umounted, removing the now empty mountpoint
		if [ -d "/mnt/utmp/$PND_NAME" ];then
			rmdir "/mnt/utmp/$PND_NAME"
		elif [ -e "/mnt/utmp/$PND_NAME" ];then
			rm "/mnt/utmp/$PND_NAME" >/dev/null 2>&1 # as it might be a symlink
		fi
		# Try umounting the PND
		umountPnd
	fi
}

main() {
	if [ $nox ]; then #the app doesnt want x to run, so we kill it and restart it once the app quits
		if [ ! $(pidof X) ]; then 
			unset $nox
		else
			applist=$(lsof /usr/lib/libX11.so.6 | awk '{print $1}'| sort | uniq)
			whitelist=$(cat ~/pndtest/whitelist) #adjust this to a fixed whitelist, maybe in the config dir
			filteredlist=$(echo -e "$applist\n\n$whitelist\n\n$whitelist" | sort | uniq -u) #whitelist appended two times so those items are always removed
			if [ ${#filteredlist} -ge 1 ]; then
				message=$(echo -e "The following applications are still running, are you sure you want to close x? \n$filteredlist")
				echo -e "?ae[34me[30m?"
				xmessage -center "$message", -buttons yes,no
				if [ $? = 102 ]; then
					exit 1
				fi
				sudo /etc/init.d/slim-init stop
				sleep 5s
			else
				echo -e "?ae[34me[30m?"
				xmessage -center "killing x, nothing of value will be lost", -buttons ok,cancel
				if [ $? = 102 ]; then
					exit 1
				fi
				# close x now, do we want to use slim stop or just kill x?
				sudo /etc/init.d/slim-init stop
				sleep 5s
			fi
		fi
	fi

	case $ACTION in
	mount)	mountPnd;;
	umount)	umountUnion;;
	run)
		mountPnd
		if [ $? -ne 0 ];then
			zenity --warning --title="Mounting the PND failed" --text="Mounting the PND failed. The application wont start. Please have a look at $LOGFILE"
			return 3
		fi
		oPWD=$(pwd)
		runApp
		cd $oPWD
		umountUnion;;
	esac


	if [ $nox ]; then #restart x if it was killed
		echo "starting x in 5s"
		sleep 5
		sudo /etc/init.d/slim-init start
	fi
}

showHelp() {
	cat <<endHELP
Usage: pnd_run.sh -p your.pnd -e executeable [-a "(arguments)"] [ -s "cd to folder inside pnd"] [-b UID (name of mountpoint/pandora/appdata)] [-x close x before launching(script needs to be started with nohup for this to work]
Usage for mounting/umounting pnd_run.sh -p your.pnd -b uid -m or -u
endHELP
}

function parseArgs() {
ACTION=run
TEMP=`getopt -o d:p:e:a:b:s:m::u::n::x::j:c: -- "$@"`
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"
while true ; do
        case "$1" in
                -p) PND="$2";shift 2;;
                -e) EXENAME="$2";shift 2 ;;
                -b) PND_NAME="$2";shift 2;;
                -s) STARTDIR="$2";shift 2;;
                -m) ACTION=mount;shift 2;;
                -u) ACTION=umount;shift 2;;
                -x) nox=1;shift 2;;
                -j) append="$2";shift 2;;
                -c) cpuspeed="$2";shift 2;;
                -d) APPDATASET=1;APPDATADIR="$2";shift 2;;
                -a)
                        case "$2" in
                                "") echo "no arguments"; shift 2 ;;
                                *) ARGUMENTS="$2";shift 2 ;;
                        esac ;;
                --) shift ; break ;;
                *) echo "Error while parsing arguments!"; showHelp; exit 1 ;;
        esac
done
}
######################################################################################
####	Main :
##
PNDARGS="$@"
parseArgs "$@"

#PND_NAME really should be something sensible and somewhat unique
#if -b is set use that as pnd_name, else generate it from PND
#get basename (strip extension if file) for union mountpoints etc, maybe  this should be changed to something specified inside the xml
#this should probably be changed to .... something more sensible
#currently only everything up to the first '.' inside the filenames is used.
PND_NAME=${PND_NAME:-"$(basename $PND | cut -d'.' -f1)"}

if [ ! -e "$PND" ]; then #check if theres a pnd suplied, need to clean that up a bit more
	echo "ERROR: selected PND($PND) file does not exist!"
	showHelp
	exit 1
fi

if [ ! "$EXENAME" ] && [[ "$ACTION" = "run" ]]; then
	echo "ERROR: no executable name provided!"
	showHelp
	exit 1
fi

PND_FSTYPE=$(file -b "$PND" | awk '{ print $1 }')	# is -p a zip/iso or folder?
MOUNTPOINT=$(df "$PND" | tail -1|awk '{print $6}')	# find out on which mountpoint the pnd is
if [ $(df "$PND"|wc -l) -eq 1 ];then			# this is actually a bug in busybox
	MOUNTPOINT="/";
elif [ ! -d "$MOUNTPOINT" ]; then 
	MOUNTPOINT="";
fi

[ ! -z $APPDATASET ] || [ -z ${MOUNTPOINT} ] && APPDATADIR=${APPDATADIR:-$(dirname $PND)/$PND_NAME}
APPDATADIR=${APPDATADIR:-${MOUNTPOINT}/pandora/appdata/${PND_NAME}}

LOGFILE="/tmp/pndrun_${PND_NAME}.out"

if [[ $ACTION != "run" ]];then #not logging mount and umount as these are from command-line
	main
elif [ $nox ]; then
	main > $LOGFILE 2>&1 & 
	disown
else
	main > $LOGFILE 2>&1
fi

