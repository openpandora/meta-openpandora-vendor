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
rm /tmp/updatedetail.log

if zenity --question --title="Update Package 2" --text="This PND updates your Pandora OS. You can safely delete it after it has finished.\nThis pack includes all updates from Hotfix 1 as well.\n\nDo you want to start the upgrade now? " --ok-label="Start now" --cancel-label="Don't do it" ; then

(
echo "10"
echo "# Updating kernel if needed"

# HotFix 1
# Kernel Update

  if [ $oldkern = $currkern ]; then   
     rm /boot/uImage.old >> /tmp/updatedetail.log
     currfree=$(df /boot | grep boot | awk '{print $4}')
     if [ $currfree -lt $needfree ]; then
        err="There is not enough diskspace on /boot/ to update the kernel.\n\nKernel couldn't be updated."
        echo "Kernel not updated - not enough diskspace on /boot/" >> /tmp/updater.log
      else
        cp 1/uImage /boot/uImage.new >> /tmp/updatedetail.log
        sync
        currkern=$(md5sum /boot/uImage.new | cut -d" " -f1)
          if [ $currkern = $newkern ]; then
            mv /boot/uImage /boot/uImage.old >> /tmp/updatedetail.log
            mv /boot/uImage.new /boot/uImage >> /tmp/updatedetail.log
            currkern=$(md5sum /boot/uImage | cut -d" " -f1)
            if [ $currkern != $newkern ]; then
               rm /boot/uImage >> /tmp/updatedetail.log
               mv /boot/uImage.old /boot/uImage >> /tmp/updatedetail.log
               err="There was a checksum error while copying the kernel.\n\nKernel couldn't be updated. Please check your SD-Card and try to recopy the PND-File."
               echo "Kernel not updated - checksum error" >> /tmp/updater.log
            fi
          else
            rm /boot/uImage.new >> /tmp/updatedetail.log
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
if [ "`opkg list-installed | grep python-shell`" ]; then
   echo "Python libraries were already installed." >> /tmp/updater.log
else 
  opkg install 1/gnome-vfs-plugin-ftp_2.24.1-r2.5_armv7a.ipk 1/gnome-vfs-plugin-http_2.24.1-r2.5_armv7a.ipk 1/python-pycairo_1.4.0-ml3.5_armv7a.ipk 1/python-pygtk_2.16.0-r1.5_armv7a.ipk 1/python-shell_2.6.4-ml9.1.5_armv7a.ipk >> /tmp/updatedetail.log
  echo "Python libraries installed" >> /tmp/updater.log
  sync
fi

# HotFix 2
# MiniMenu Update

echo "30"
echo "# Installing updated MiniMenu"
 if [ $oldmmenu1 = $currmmenu -o $oldmmenu2 = $currmenu]; then   
     rm /usr/bin/mmenu.old >> /tmp/updatedetail.log
     cp 2/mmenu /usr/bin/mmenu.new >> /tmp/updatedetail.log
     cp 2/mmenu.conf /etc/pandora/conf/mmenu.conf.new >> /tmp/updatedetail.log
        sync
        currmmenu=$(md5sum /usr/bin/mmenu.new | cut -d" " -f1)
          if [ $currmmenu = $newmmenu ]; then
            mv /usr/bin/mmenu /usr/bin/mmenu.old >> /tmp/updatedetail.log
            mv /etc/pandora/conf/mmenu.conf /etc/pandora/conf/mmenu.conf.old >> /tmp/updatedetail.log
            mv /usr/bin/mmenu.new /usr/bin/mmenu >> /tmp/updatedetail.log
            mv /etc/pandora/conf/mmenu.conf.new /etc/pandora/conf/mmenu.conf >> /tmp/updatedetail.log
            currmmenu=$(md5sum /boot/uImage | cut -d" " -f1)
            if [ $currmmenu != $newmmenu ]; then
               rm /usr/bin/mmenu >> /tmp/updatedetail.log
	       rm /etc/pandora/conf/mmenu.conf >> /tmp/updatedetail.log
               mv /etc/pandora/conf/mmenu.conf.old /etc/pandora/conf/mmenu.conf >> /tmp/updatedetail.log
               mv /usr/bin/mmenu.old /usr/bin/mmenu >> /tmp/updatedetail.log
               err="There was a checksum error while copying MiniMenu.\n\nMiniMenu couldn't be updated. Please check your SD-Card and try to recopy the PND-File."
               echo "MiniMenu not updated - checksum error" >> /tmp/updater.log
            fi
          else
            rm /usr/bin/mmenu.new >> /tmp/updatedetail.log
            rm /etc/pandora/conf/mmenu.conf.new >> /tmp/updatedetail.log
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
if [ "`opkg list-installed | grep boost-system`" ]; then
  echo "Boost library was already installed" >> /tmp/updater.log
else  
  opkg install 2/boost_1.41.0-r8.1.5_armv7a.ipk 2/boost-filesystem_1.41.0-r8.1.5_armv7a.ipk 2/boost-graph_1.41.0-r8.1.5_armv7a.ipk 2/boost-iostreams_1.41.0-r8.1.5_armv7a.ipk 2/boost-program-options_1.41.0-r8.1.5_armv7a.ipk 2/boost-python_1.41.0-r8.1.5_armv7a.ipk 2/boost-regex_1.41.0-r8.1.5_armv7a.ipk 2/boost-serialization_1.41.0-r8.1.5_armv7a.ipk 2/boost-signals_1.41.0-r8.1.5_armv7a.ipk 2/boost-system_1.41.0-r8.1.5_armv7a.ipk 2/boost-test_1.41.0-r8.1.5_armv7a.ipk >> /tmp/updatedetail.log
  echo "Boost library installed" >> /tmp/updater.log
  sync
fi

# Bugfixes in Scripts

echo "50"
echo "# Installing updated scripts"
if [ ! -f /usr/bin/stopmmenu ]; then
  cp 2/op_bluetooth.sh /usr/pandora/scripts/ >> /tmp/updatedetail.log
  cp 2/op_calibrate.sh /usr/pandora/scripts/ >> /tmp/updatedetail.log
  cp 2/op_datetime.sh /usr/pandora/scripts/ >> /tmp/updatedetail.log
  cp 2/op_lcdsettings.sh /usr/pandora/scripts/ >> /tmp/updatedetail.log
  cp 2/op_nubmode.sh /usr/pandora/scripts/ >> /tmp/updatedetail.log
  cp 2/op_startupmanager.sh /usr/pandora/scripts/ >> /tmp/updatedetail.log
  cp 2/op_switchgui.sh /usr/pandora/scripts/ >> /tmp/updatedetail.log
  cp 2/op_usermanager.sh /usr/pandora/scripts/ >> /tmp/updatedetail.log
  cp 2/gui.conf /etc/pandora/conf/ >> /tmp/updatedetail.log
  cp 2/op_bluetooth.desktop /usr/share/applications/ >> /tmp/updatedetail.log   
  cp 2/rc.wl1251 /etc/init.d/wl1251-init >> /tmp/updatedetail.log
  cp 2/interfaces /etc/network/ >> /tmp/updatedetail.log
  cp 2/stopmmenu /usr/bin/stopmmenu >> /tmp/updatedetail.log
  echo "The scripts have been updated" >> /tmp/updater.log
  sync
else
  echo "The scripts were up-to-date" >> /tmp/updater.log
fi


# Zenity Progress goes here
fi







