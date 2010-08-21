DESCRIPTION = "Kernel drivers for the TI WL1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

SRCREV = "1b4f73540778042846ca3ddac9ddb0c1d21ccbc0"

SRC_URI = " \
           git://git.openpandora.org/pandora-wifi.git;protocol=git;branch=compat-wireless \
"

SRC_URI += " \
	file://rc.wl1251 \
	file://50-compat_firmware.rules \
	file://compat_firmware.sh \
"

RDEPENDS = "udev"

inherit update-rc.d

INITSCRIPT_NAME = "wl1251-init"
INITSCRIPT_PARAMS = "start 30 5 2 . stop 40 0 1 6 ."

S = "${WORKDIR}/git"

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
          install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/compat
          install -m 0644 ${S}/compat/*.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/compat
          install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/net/mac80211
          install -m 0644 ${S}/net/mac80211/*.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/net/mac80211
          install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/net/wireless
          install -m 0644 ${S}/net/wireless/*.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/net/wireless
          install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/net/rfkill
          install -m 0644 ${S}/net/rfkill/*.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/net/rfkill
          install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx      
          install -m 0644 ${S}/drivers/net/wireless/wl12xx/wl1251.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx
          install -m 0644 ${S}/drivers/net/wireless/wl12xx/wl1251_sdio.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx
          
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.wl1251 ${D}${sysconfdir}/init.d/wl1251-init

          # Install UDEV rules to /lib/udev/rules.d not /etc/udev/rules.d as they are system rules.
          install -d ${D}${base_libdir}/udev/rules.d/
          install -m 0644 ${WORKDIR}/50-compat_firmware.rules ${D}${base_libdir}/udev/rules.d/
          install -m 0755 ${WORKDIR}/compat_firmware.sh ${D}${base_libdir}/udev/rules.d/          
}

FILES_${PN} += "/lib/udev/rules.d/*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/compat/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/mac80211/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/wireless/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/net/rfkill/*.ko.*"
FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/updates/kernel/drivers/net/wireless/wl12xx/*.ko.*"
