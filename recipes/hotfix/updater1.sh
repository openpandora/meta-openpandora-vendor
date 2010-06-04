#### THIS SCRIPT IS NOT FINISHED YET! ####

#!/bin/bash
newkern=b00a5d617f11366689488395b19411de
oldkern=3112d1782a90c2c87ae17a152a35deae
currkern=$(md5sum /boot/uImage | cut -d" " -f1)
needfree=$(ls -lk uImage | grep uImage | cut -d" " -f5)
oldinterfaces=23f72750f2f7335b9c2ed3f55aaa5061
oldrcwl1251=7a6361e842f0f589418218436affbe07
newmmenu=af66a5118a9bfef8eca5de13ee64c6a1
oldmmenu1=
oldmmenu2=fa45e9bc91c48640a9ea592de5fbeb3c
oldmmenuconf1=
oldmmenuconf2=c90d33c362121ddd0e24e9eac0b82da9
newmmenuconf=d3b237cf95ff6c6e81b23483e87391e1
currmmenu=$(md5sum /usr/bin/mmenu | cut -d" " -f1)
currmmenuconf=$(md5sum /etc/pandora/conf/mmenu.conf | cut -d" " -f1)
err="Your system has been updated without any errors."

rm /tmp/updater.log

if zenity --question --title="Update Package 2" --text="This PND updates your Pandora OS. You can safely delete it after it has finished.\nThis pack includes all updates from Hotfix 1 as well.\n\nDo you want to start the upgrade now? " --ok-label="Start now" --cancel-label="Don't do it" ; then

(
echo "10"
echo "# Updating kernel if needed"

# HotFix 1
# Kernel Update

  if [ $oldkern = $currkern ]; then   
     rm /boot/uImage.old
     currfree=$(df /boot | grep boot | awk '{print $4}')
     if [ $currfree -lt $needfree ]; then
        err="There is not enough diskspace on /boot/ to update the kernel.\n\nKernel couldn't be updated."
        echo "Kernel not updated - not enough diskspace on /boot/" >> /tmp/updater.log
      else
        cp uImage /boot/uImage.new
        sync
        currkern=$(md5sum /boot/uImage.new | cut -d" " -f1)
          if [ $currkern = $newkern ]; then
            mv /boot/uImage /boot/uImage.old
            mv /boot/uImage.new /boot/uImage
            currkern=$(md5sum /boot/uImage | cut -d" " -f1)
            if [ $currkern != $newkern ]; then
               rm /boot/uImage
               mv /boot/uImage.old /boot/uImage
               err="There was a checksum error while copying the kernel.\n\nKernel couldn't be updated. Please check your SD-Card and try to recopy the PND-File."
               echo "Kernel not updated - checksum error" >> /tmp/updater.log
            fi
          else
            rm /boot/uImage.new
            err="There was a checksum error while copying the kernel.\n\nKernel couldn't be updated. Please check your SD-Card and try to recopy the PND-File."
            echo "Kernel not updated - checksum error" >> /tmp/updater.log
          fi
     fi
  fi
  echo "Kernel successfully updated" >> /tmp/updater.log
  sync

# Libraries for HotFix 1
  
echo "20"
echo "# Installing missing Python libraries"
if [ ! -f /usr/lib/glob.py ];
  opkg install gnome-vfs-plugin-ftp_2.24.1-r2.5_armv7a.ipk gnome-vfs-plugin-http_2.24.1-r2.5_armv7a.ipk python-pycairo_1.4.0-ml3.5_armv7a.ipk python-pygtk_2.16.0-r1.5_armv7a.ipk python-shell_2.6.4-ml9.1.5_armv7a.ipk
  echo "Python libraries successfully updated" >> /tmp/updater.log
  sync
else 
  echo "Python libraries were installed." >> /tmp/updater.log
fi

# HotFix 2
# MiniMenu Update

echo "30"
echo "# Installing updated MiniMenu"
 if [ $oldmmenu1 = $currmmenu -o $oldmmenu2 = $currmenu]; then   
     rm /usr/bin/mmenu.old
     cp 2/mmenu /usr/bin/mmenu.new
     cp 2/mmenu.conf /etc/pandora/conf/mmenu.conf.new
        sync
        currmmenu=$(md5sum /usr/bin/mmenu.new | cut -d" " -f1)
          if [ $currmmenu = $newmmenu ]; then
            mv /usr/bin/mmenu /usr/bin/mmenu.old
            mv /etc/pandora/conf/mmenu.conf /etc/pandora/conf/mmenu.conf.old
            mv /usr/bin/mmenu.new /usr/bin/mmenu
            mv /etc/pandora/conf/mmenu.conf.new /etc/pandora/conf/mmenu.conf
            currmmenu=$(md5sum /boot/uImage | cut -d" " -f1)
            if [ $currmmenu != $newmmenu ]; then
               rm /usr/bin/mmenu
	       rm /etc/pandora/conf/mmenu.conf
               mv /etc/pandora/conf/mmenu.conf.old /etc/pandora/conf/mmenu.conf
               mv /usr/bin/mmenu.old /usr/bin/mmenu
               err="There was a checksum error while copying MiniMenu.\n\nMiniMenu couldn't be updated. Please check your SD-Card and try to recopy the PND-File."
               echo "MiniMenu not updated - checksum error" >> /tmp/updater.log
            fi
          else
            rm /usr/bin/mmenu.new
            rm /etc/pandora/conf/mmenu.conf.new
            err="There was a checksum error while copying MiniMenu.\n\nMiniMenu couldn't be updated. Please check your SD-Card and try to recopy the PND-File."
            echo "MiniMenu not updated - checksum error" >> /tmp/updater.log
          fi
     fi
  fi
  echo "MiniMenu successfully updated" >> /tmp/updater.log
  sync

# Libraries for HotFix 2

echo "40"
echo "# Installing Boost Library"
if [ ! -f /usr/lib/glob.py ];
  opkg install 2/
  echo "Boost library successfully updated" >> /tmp/updater.log
  sync
else 
  echo "Boost library was already up-to-date." >> /tmp/updater.log
fi

# Bugfixes in Scripts

echo "50"
echo "# Installing updated scripts"


)


# Zenity Progress goes here
fi