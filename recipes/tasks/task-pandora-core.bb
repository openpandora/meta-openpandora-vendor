DESCRIPTION = "Task file for default core/console apps and libs in the Pandora image"

# Use this task as a base to ship all kernel modules and make sure firmware and drivers are installed for BT and WiFi.
# Please see metadata/openpandora.oe.git/packages/pandora-system/pandora-firmware/pandora-firmware/readme.txt for info on the hacks for firmware.

# Don't forget to bump the PR if you change it.

PR = "r18"

inherit task 

AUFS = " \
#  aufs2-27 \
  aufs2-util \
"

BLUETOOTH = " \
  blueprobe \
  bluez4 gst-plugin-bluez \
  libsndfile1 libasound-module-bluez \
"

# Package up the boot scripts and bootchart to help us work to drop the startup time.
BOOT = " \
  pandora-uboot-scripts \
  bootchart \
"

WIRELESS = " \
  pandora-firmware \
  wl1251-modules \
#  pandora-wifi pandora-wifi-tools \
  wireless-tools \
  wpa-supplicant \  
  networkmanager netm-cli \
"

MEDIA_LIBS = " \
  libmodplug \
  libsdl-x11 libsdl-mixer libsdl-image \
  libsdl-gfx libsdl-net libsdl-ttf \
  mikmod \
  speex \  
  
"
OPENGLES = " \
  omap3-sgx-modules devmem2 \
  libgles-omap3 \
  libgles-omap3-rawdemos \
"

PAM = " \
  libpam \
  libpam-meta \
"

PANDORA_LIBS = " \
  pandora-libpnd lsof \
  omap3-deviceid \
  pandora-skel \
"

SUDO = " \
  sudo sudo-enable-wheel-group \ 
  pandora-sudoers \
"

SSH = " \
  openssh-scp \
  openssh-ssh \
"

TOUCHSCREEN = " \
  tslib tslib-tests tslib-calibrate pointercal \
"

FS_SUPPORT = " \
#  nfs-utils \
  nfs-utils-client \
  fuse fuse-utils \
  sshfs-fuse gmailfs curlftpfs \
  ntfs-3g \
  squashfs-tools \
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
  minicom \
  nano \
  gdb \
  sessreg \
"

# Add extra util-linux-ng utils to image. 
# TODO: Fix util-linux-ng to meta depend on all subpackages.
UTIL_LINUX_NG_EXTRAS = " \
  util-linux-ng-losetup util-linux-ng-mountall \
  util-linux-ng-swaponoff \
"
  
RDEPENDS_${PN} = "\
  task-base-extended \
  task-proper-tools \
  ${AUFS} \
  ${WIRELESS} \
  ${BLUETOOTH} \  
  ${BOOT} \
  ${MEDIA_LIBS} \
  ${OPENGLES} \
  ${PANDORA_LIBS} \
  ${SSH} \
  ${SUDO} \
  ${TOUCHSCREEN} \
  ${FS_SUPPORT} \
  ${EXTRA_TOOLS} \
  ${UTIL_LINUX_NG_EXTRAS} \
#        packagekit \
  python-pygame \
  alsa-utils alsa-utils-alsactl alsa-utils-alsamixer alsa-utils-aplay \
  rdesktop \
  mplayer \
  \
#  angstrom-zeroconf-audio \
  angstrom-led-config \ 
  \
  ${PAM} \
"

# Make sure we install all kernel modules with the Pandora images
RRECOMMENDS_${PN} += "kernel-modules"

PACKAGE_ARCH = "${MACHINE_ARCH}"

RRECOMMENDS_${PN}_append_armv7a = " \
#	gnash gnash-browser-plugin \
	omapfbplay \
"
