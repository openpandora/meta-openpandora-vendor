DESCRIPTION = "Kernel drivers for the TI WL1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

SRC_URI += " \
	http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2010-03-10.tar.bz2;name=compat-wireless \
	file://0001-wl1251-make-local-symbols-static.patch;patch=1 \
	file://0002-wl1251-fix-ELP_CTRL-register-accesses-when-using-SDI.patch;patch=1 \
	file://0003-wl1251-reduce-eeprom-read-wait-time.patch;patch=1 \
	file://0004-wl1251-fix-potential-crash.patch;patch=1 \
	file://0005-pandora-hacks.patch;patch=1 \
	file://no-scan-while-connected.patch;patch=1 \
	file://print-chip-id.patch;patch=1 \
	file://rc.wl1251 \
	file://50-compat_firmware.rules \
	file://compat_firmware.sh \
"

RDEPENDS = "udev"

SRC_URI[compat-wireless.md5sum] = "bd1875aebcc2a72f66529ba625751a8c"
SRC_URI[compat-wireless.sha256sum] = "dd8d8bc79ccb24a1d043325979e337678991b79f2011df160c2d924f181a82c9"

inherit update-rc.d

INITSCRIPT_NAME = "wl1251-init"
INITSCRIPT_PARAMS = "start 30 5 2 . stop 40 0 1 6 ."

S = "${WORKDIR}/compat-wireless-2010-03-10"

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
          install -d ${D}/lib/modules/${KERNEL_VERSION}/updates/compat
          install -m 0644 ${S}/compat/*.ko ${D}/lib/modules/${KERNEL_VERSION}/updates/compat
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

          install -d ${D}${sysconfdir}/udev/rules.d/
          install -m 0644 ${WORKDIR}/50-compat_firmware.rules ${D}${sysconfdir}/udev/rules.d/
          install -m 0755 ${WORKDIR}/compat_firmware.sh ${D}${sysconfdir}/udev/rules.d/          
}

FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/compat/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/mac80211/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/wireless/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/rfkill/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx/*.ko.*"
