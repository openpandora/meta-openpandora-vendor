DESCRIPTION = "Task file for default core/console apps in the Pandora image"

# Use this task as a base to ship all kernel modules and make sure firmware and drivers are installed for BT and WiFi.
# Please see metadata/openpandora.oe.git/packages/pandora-system/pandora-firmware/pandora-firmware/readme.txt for info on the hacks for firmware.

# Don't forget to bump the PR if you change it.

PR = "r3.1"

inherit task 

RDEPENDS_${PN} = "\
  task-base-extended \
  task-proper-tools \
  pandora-firmware \
  wl1251-modules \
#        pandora-wifi pandora-wifi-tools \
  wpa-supplicant \
  pandora-libpnd lsof \
  omap3-deviceid \	
  omap3-sgx-modules devmem2 \
  libgles-omap3 libgles-omap3-demos \
#        packagekit \
  libsdl-gfx libsdl-net mikmod \
  nfs-utils nfs-utils-client \
  tslib tslib-tests tslib-calibrate pointercal \
  fbgrab fbset fbset-modes \
  portmap \
  fuse sshfs-fuse ntfs-3g \
  file \
  aufs aufs-tools \
  socat \
  strace \
  python-pygame \
  ksymoops \
  kexec-tools \
  alsa-utils alsa-utils-alsactl alsa-utils-alsamixer alsa-utils-aplay \
  openssh-scp \
  openssh-ssh \
  bluez4 \
  wireless-tools \
  rdesktop \
  networkmanager netm-cli \
  openssh-scp openssh-ssh \
  mplayer \
  \
  zip \        
  gzip \
  bash \
  bzip2 \  
  sudo \ 
  minicom \
  nano \        
  \
"

# Make sure we install all kernel modules with the Pandora images
RRECOMMENDS_${PN} += "kernel-modules"

PACKAGE_ARCH = "${MACHINE_ARCH}"

RRECOMMENDS_${PN}_append_armv7a = " \
	gnash gnash-browser-plugin \
	omapfbplay \
"
