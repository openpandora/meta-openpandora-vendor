DESCRIPTION = "Kernel drivers for the TI WL1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

SRC_URI += " \
#	http://djwillis.openpandora.org/pandora/wifi/wl1251-wireless-2009-10-08-rev2.zip \
#	http://djwillis.openpandora.org/pandora/wifi/wl1251-wireless-2009-10-28-take2.zip \
	http://djwillis.openpandora.org/pandora/wifi/wl1251-wireless-2009-10-28-take3.zip \	
	file://rc.wl1251 \
"

inherit update-rc.d

INITSCRIPT_NAME = "wl1251-init"
INITSCRIPT_PARAMS = "start 30 5 2 . stop 40 0 1 6 ."

#S = "${WORKDIR}/compat-wireless-2009-08-30"
S = "${WORKDIR}/compat-wireless-2009-10-28"

inherit module

PARALLEL_MAKE = ""

EXTRA_OEMAKE = " \
          'KLIB=${STAGING_KERNEL_DIR}' \
          'KLIB_BUILD=${STAGING_KERNEL_DIR}' \
          "
          
do_compile_prepend() {
          cd ${S}
          chmod +x ${S}/scripts/*
}

do_install() {
          mkdir -p ${D}/lib/modules/${KERNEL_VERSION}/kernel/net/mac80211
          cp ${S}/net/mac80211/*.ko ${D}/lib/modules/${KERNEL_VERSION}/kernel/net/mac80211
          mkdir -p ${D}/lib/modules/${KERNEL_VERSION}/kernel/net/wireless
          cp ${S}/net/wireless/*.ko ${D}/lib/modules/${KERNEL_VERSION}/kernel/net/wireless
          mkdir -p ${D}/lib/modules/${KERNEL_VERSION}/kernel/net/rfkill
          cp ${S}/net/rfkill/*.ko ${D}/lib/modules/${KERNEL_VERSION}/kernel/net/rfkill
          mkdir -p ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/wl12xx      
          cp ${S}/drivers/net/wireless/wl12xx/wl1251.ko ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/wl12xx
          cp ${S}/drivers/net/wireless/wl12xx/wl1251_sdio.ko ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/wl12xx
          install -d ${D}${sysconfdir}/init.d/
          cp -pP ${WORKDIR}/rc.wl1251 ${D}${sysconfdir}/init.d/wl1251-init
}

FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/kernel/net/mac80211/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/kernel/net/wireless/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/kernel/net/rfkill/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/wl12xx/*.ko.*"
