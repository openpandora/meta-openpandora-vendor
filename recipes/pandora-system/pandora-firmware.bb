DESCRIPTION = "Install binary firmware for Bluetooth and WiFi into the image."
LICENSE = "proprietary-binary"
RRECOMMENDS_${PN} = "kernel-module-firmware-class"
PR = "r4"

SRC_URI = " \
        file://brf6300.bin \
        file://Fw1251r1c.bin \
"

SUMMARY = "This is required to support the Bluetooth and WiFi modules on the Pandora"
S = "${WORKDIR}"

do_install() {
        install -d ${D}/lib/firmware
        install -m 0644 ${S}/brf6300.bin ${S}/Fw1251r1c.bin ${D}/lib/firmware/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "/lib/firmware"

COMPATIBLE_MACHINE = "omap3-pandora"
