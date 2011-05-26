DESCRIPTION = "Install binary firmware for Bluetooth and WiFi into the image."
LICENSE = "proprietary-binary"
RRECOMMENDS_${PN} = "kernel-module-firmware-class"
PR = "r4"

SRC_URI = " \
        file://brf6300.bin \
        file://wl1251-fw.bin \
        file://bluetooth-conf \        
"

SUMMARY = "This is required to support the Bluetooth and WiFi modules on the Pandora"
S = "${WORKDIR}"

do_install() {
        install -d ${D}${base_libdir}/firmware
        install -m 0644 ${S}/brf6300.bin ${S}/wl1251-fw.bin ${D}${base_libdir}/firmware/
        install -d ${D}${sysconfdir}/sysconfig
        install -m 0755 ${S}/bluetooth-conf ${D}${sysconfdir}/sysconfig/bluetooth     
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${base_libdir}/firmware ${sysconfdir}/sysconfig"

COMPATIBLE_MACHINE = "omap3-pandora"
