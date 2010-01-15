DESCRIPTION = "Kernel drivers for the TI WL1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

SRC_URI += " \
	http://djwillis.openpandora.org/pandora/wifi/wl1251-wireless-2009-10-28-take3.zip \	
	file://rc.wl1251 \
"

inherit update-rc.d

INITSCRIPT_NAME = "wl1251-init"
INITSCRIPT_PARAMS = "start 30 5 2 . stop 40 0 1 6 ."

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
          install -d ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/net/mac80211
          install -m 0644 ${S}/net/mac80211/*.ko ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/net/mac80211
          install -d ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/net/wireless
          install -m 0644 ${S}/net/wireless/*.ko ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/net/wireless
          install -d ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/net/rfkill
          install -m 0644 ${S}/net/rfkill/*.ko ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/net/rfkill
          install -d ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx      
          install -m 0644 ${S}/drivers/net/wireless/wl12xx/wl1251.ko ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx
          install -m 0644 ${S}/drivers/net/wireless/wl12xx/wl1251_sdio.ko ${D}/lib/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx
          
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.wl1251 ${D}${sysconfdir}/init.d/wl1251-init
}

FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/mac80211/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/wireless/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/rfkill/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx/*.ko.*"
