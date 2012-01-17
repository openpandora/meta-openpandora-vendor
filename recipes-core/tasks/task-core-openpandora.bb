DESCRIPTION = "Task file for default core/console apps and libs in the OpenPandora image"

# Use this task as a base to ship all kernel modules and setup basic OpenPandora userspace.

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

# Don't forget to bump the PR if you change it.
PR = "r4"

inherit task 

AUFS = " \
  aufs-util \
"

BLUETOOTH = " \
  bluez4 \
  libsndfile1 libasound-module-bluez \
"

# Package up the boot scripts and bootchart to help us work to drop the startup time.
BOOT = " \
  pandora-uboot-scripts \
  openpandora-u-boot-autoboot-sd \
  bootchart \
  mtd-utils \
"

# Package BOOST libs so people can use them in apps. It will pull in the RRECOMENDS.
BOOST = " \
  boost \
"

# Install 'real' tools over BusyBox versions.
COREUTILS = " \
  coreutils \
  util-linux \
"

WIRELESS = " \
  wireless-tools \
  wpa-supplicant \  
  networkmanager \
  rfkill \
"

MEDIA_LIBS = " \
  libmodplug \
  libsdl libsdl-mixer libsdl-image \
  libsdl-gfx libsdl-net libsdl-ttf \
  libpng \
  faad2 \
  speex \  
  flac \
  audiofile \
"

OPENGLES = " \
  omap3-sgx-modules devmem2 \
  libgles-omap3 \
"

PAM = " \
  libpam \
"

PANDORA_LIBS = " \
  pandora-libpnd lsof \
  omap3-deviceid \
  pandora-skel \
  pandora-state \
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
  nfs-utils-client \
  fuse fuse-utils \
  sshfs-fuse \
  ntfs-3g \
  squashfs-tools \
"

EXTRA_TOOLS = " \
  avahi \
  fbset fbset-modes \
  portmap \
  file \
  socat \
  strace \
  screen \
  rsync \
  zip \        
  gzip \
  bash \
  bzip2 \  
  minicom \
  nano \
  gdb \
  sessreg \
  lua5.1 \
  tzdata \
"
  
RDEPENDS_${PN} = "\
  task-core-basic-extended \
  task-core-dev-utils \
  task-base-extended \
  ${AUFS} \
  ${BOOST} \
  ${COREUTILS} \
  ${WIRELESS} \
  ${BLUETOOTH} \  
  ${BOOT} \
  ${MEDIA_LIBS} \
  ${OPENGLES} \
  ${PANDORA_LIBS} \
  ${PAM} \  
  ${SSH} \
  ${SUDO} \
  ${TOUCHSCREEN} \
  ${FS_SUPPORT} \
  ${EXTRA_TOOLS} \
  python-misc \
  python-modules \
  alsa-utils alsa-utils-alsactl alsa-utils-alsamixer alsa-utils-aplay \
  freerdp \
  \
  led-config \ 
"

# Make sure we install all kernel modules with the Pandora images
RRECOMMENDS_${PN} += "kernel-modules"

PACKAGE_ARCH = "${MACHINE_ARCH}"
