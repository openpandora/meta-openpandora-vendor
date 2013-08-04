#!/bin/sh
kernel_path="/boot/uImage-3"

zenity --question --title="Update Firmware OS" --text="This little tool helps you to keep your firmware OS up-to-date with the latest tweaks.\n\nPlease note that this is in TESTING state and\nmight break parts of your system with unstable packages!\n\nMake sure your Pandora is connected to the internet and click the Upgrade-Button.\n\n" --ok-label="Upgrade OS" --cancel-label="Quit" || exit 0

# check free space
root_free=`df | grep '/$' | sed -e '2~1d' | awk '{print $4}'`
if [ "$root_free" -lt 20000 ]; then
  zenity --error --text "There is not enough free space left in root partition
(at least 20MB is required).
This usually means your NAND is almost full.

Delete some files and try again. Alternatively you can do a full reflash."
  exit 1
fi

# check for default angstrom feeds
if cat /etc/opkg/*.conf | awk -F# '{printf $1}' | grep -q www.angstrom-distribution.org; then
  zenity --error --text "There seem to be Angstrom feeds in your opkg configs, \
upgraging from them is known to make the system unbootable.
Aborting."
  exit 1
fi

rm -f /tmp/upgrade_ok
kernelmd5_old=`md5sum $kernel_path`

# reminder: don't use '&&' '||' ... after tee, it breaks set -e, no idea why
terminal -x bash -c \
  '( set -e; \
     cd /tmp/; \
     echo "Updating package lists..."; \
     opkg update 2>&1; \
     echo "Checking for updated packages..."; \
     opkg upgrade 2>&1; \
     touch /tmp/upgrade_ok; \
     sync ) | tee /tmp/upgrade.log; \
   test -e /tmp/upgrade_ok || sleep 3'

sync

kernelmd5_new=`md5sum $kernel_path`

if test -e /tmp/upgrade_ok; then
  rm -f /tmp/upgrade_ok
  zenity --info --title="Upgrade complete" \
    --text "All operations have been finished.\n\nYou can find a logfile at /tmp/upgrade.log"
  if [ "$kernelmd5_old" != "$kernelmd5_new" ]; then
    zenity --question --title="Kernel updated" \
      --text "The kernel has been updated,\nreboot is needed to start it.\n\nReboot now?" \
      --ok-label="Yes" --cancel-label="No, do it later" \
      && reboot
  fi
else
  zenity --error --title="Errors detected" \
    --text "Errors detected during update.\n\nYou can find a logfile at /tmp/upgrade.log"
fi
