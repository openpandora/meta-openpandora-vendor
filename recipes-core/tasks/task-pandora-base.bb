DESCRIPTION = "Task file for base OpenPandora specific bits like libPND and firmware"

# Note: This task assumes your building an X image and will pull in an XServer and all that jazz.
# TODO: Break down again into GUI and CLI aspects like the classic trees, more testing needed 1st.

# Don't forget to bump the PR if you change it.

PR = "r3"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"
inherit task 

# Package up the boot scripts and bootchart to help us work to drop the startup time.
BOOT = " \
  pandora-uboot-scripts \
  mtd-utils \
"

BLUETOOTH = " \
  bluez4 \
  libsndfile1 libasound-module-bluez \
"

WIRELESS = " \
  openpandora-firmware wl1251-init \
  wireless-tools \
  wpa-supplicant \  
"

OPENGLES = " \
  omap3-sgx-modules devmem2 \
  libgles-omap3 \
"

PANDORA = " \
  lsof \
  omap3-deviceid \
  pandora-skel \
  pandora-state \
  pandora-first-run-wizard  \
  pandora-scripts \
  pandora-wallpaper-official \
  pandora-xfce-defaults \
"

SUDO = " \
  pandora-sudoers \
"

TOUCHSCREEN = " \
  tslib tslib-tests tslib-calibrate pointercal \
  gtk-touchscreen-mode-enable \
  libgtkstylus \  
"

RDEPENDS_${PN} = "\
  ${WIRELESS} \
  ${BLUETOOTH} \  
  ${BOOT} \
  ${OPENGLES} \
  ${PANDORA} \
  ${SUDO} \
  ${TOUCHSCREEN} \
"

# Make sure we install all kernel modules with the Pandora images
RRECOMMENDS_${PN} += "kernel-modules"

PACKAGE_ARCH = "${MACHINE_ARCH}"
