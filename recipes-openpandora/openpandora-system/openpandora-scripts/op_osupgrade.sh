#!/bin/sh
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

terminal -x bash -c \
  'echo "Updating package lists..." && \
   opkg update 2>&1 | tee /tmp/upgrade.log && test ${PIPESTATUS[0]} -eq 0 && \
   echo "Checking for updated packages..." && \
   opkg upgrade 2>&1 | tee -a /tmp/upgrade.log && test ${PIPESTATUS[0]} -eq 0 && \
   touch /tmp/upgrade_ok || sleep 3'

if test -e /tmp/upgrade_ok; then
  zenity --info --title="Upgrade complete" \
    --text "All operations have been finished.\n\nYou can find a logfile at /tmp/upgrade.log"
else
  zenity --error --title="Errors detected" \
    --text "Errors detected during update.\n\nYou can find a logfile at /tmp/upgrade.log"
fi
rm -f /tmp/upgrade_ok
