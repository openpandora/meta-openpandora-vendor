DESCRIPTION = "Tools to support the TI1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

DEPENDS = "pandora-wifi"

PR = "r3"

# Check the include for the source location/GIT SRCREV etc.
require pandora-wifi.inc

SRC_URI += " \
	file://wlan_cu_makefile.patch;patch=1 \
"

#
#make  CROSS_COMPILE=${KERNEL_PREFIX} CROSS_COMPILE=arm-none-linux-gnueabi- V=1 ARCH=arm KERNEL_DIR=/storage/file-store/Projects/Pandora/pandora-kernel.git OUTPUT_DIR=/storage/file-store/Projects/Pandora/pandora-wifi.git

do_compile_prepend() {
	cd ${S}/sta_dk_4_0_4_32/CUDK/CLI/
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/wlan_cu ${D}${bindir}
#	install -m 0755 ${S}/tiwlan_loader ${D}${bindir}
}

FILES_${PN} = "/usr/bin/wlan_cu /usr/bin/tiwlan_loader"

