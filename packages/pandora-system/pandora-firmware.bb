DESCRIPTION = "Install binary firmware for Bluetooth and WiFi into the image."
SUMMARY = "This is required to support the Bluetooth and WiFi modules on the Pandora"
LICENCE = "proprietary-binary"

COMPATIBLE_MACHINE = "omap3-pandora"
PR = "r1"

PACKAGE_ARCH = "${MACHINE_ARCH}"

RRECOMMENDS = "kernel-module-firmware-class"

SRC_URI = "file://brf6300.bin \
	file://Fw1251r1c.bin \
"

S = "${WORKDIR}"

FILES_${PN} = "/lib"

do_install() {
	install -d ${D}/lib/firmware/
	install -m 0644 ${S}/brf6300.bin ${S}/Fw1251r1c.bin ${D}/lib/firmware/
}
