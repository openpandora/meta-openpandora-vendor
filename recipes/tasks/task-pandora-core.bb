DESCRIPTION = "Task file for default core/console apps in the Pandora image"

# Use this task as a base to ship all kernel modules and make sure firmware and drivers are installed for BT and WiFi.
# Please see metadata/openpandora.oe.git/packages/pandora-system/pandora-firmware/pandora-firmware/readme.txt for info on the hacks for firmware.

# Don't forget to bump the PR if you change it.

PR = "r7"

inherit task 

AUFS = " \
  aufs2-27 \
  aufs2-util \
"

BLUETOOTH = " \
  blueprobe \
  bluez4 gst-plugin-bluez \
  libsndfile1 libasound-module-bluez \
"

WIRELESS = " \
  pandora-firmware \
  wl1251-modules \
#  pandora-wifi pandora-wifi-tools \
  wireless-tools \
  wpa-supplicant \  
  networkmanager netm-cli \  
"

OPENGLES = " \
  omap3-sgx-modules devmem2 \
  libgles-omap3 libgles-omap3-demos \
"

PAM = " \
  libpam \
  libpam-meta \
"

SSH = " \
  openssh-scp \
  openssh-ssh \
"

PANDORA_LIBS = " \
  pandora-libpnd lsof \
  omap3-deviceid \
  pandora-skel \
"

TOUCHSCREEN = " \
  tslib tslib-tests tslib-calibrate pointercal \
"

FS_SUPPORT = " \
  nfs-utils nfs-utils-client \
  fuse sshfs-fuse ntfs-3g \
"

EXTRA_TOOLS = " \
  avahi \
  fbgrab fbset fbset-modes \
  portmap \
  file \
  socat \
  strace \
  ksymoops \
  kexec-tools \
  zip \        
  gzip \
  bash \
  bzip2 \  
  sudo sudo-enable-wheel-group \ 
  minicom \
  nano \
"

RDEPENDS_${PN} = "\
  task-base-extended \
  task-proper-tools \
  ${AUFS} \
  ${WIRELESS} \
  ${BLUETOOTH} \  
  ${OPENGLES} \
  ${PANDORA_LIBS} \
  ${SSH} \
  ${TOUCHSCREEN} \
  ${FS_SUPPORT} \
  ${EXTRA_TOOLS} \
#        packagekit \
  libsdl-gfx libsdl-net mikmod \
  python-pygame \
  alsa-utils alsa-utils-alsactl alsa-utils-alsamixer alsa-utils-aplay \
  rdesktop \
  mplayer \
  \
  angstrom-zeroconf-audio \
  angstrom-led-config \ 
  \
  ${PAM} \
"

# Make sure we install all kernel modules with the Pandora images
RRECOMMENDS_${PN} += "kernel-modules"

PACKAGE_ARCH = "${MACHINE_ARCH}"

RRECOMMENDS_${PN}_append_armv7a = " \
	gnash gnash-browser-plugin \
	omapfbplay \
"
