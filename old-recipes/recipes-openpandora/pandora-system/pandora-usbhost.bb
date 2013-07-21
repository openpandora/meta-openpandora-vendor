DESCRIPTION = "Startup service for USB Host"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

COMPATIBLE_MACHINE = "omap3-pandora"

PR = "r1"

SRC_URI = " \
          file://LICENSE \
          file://rc.usbhost \
"

do_install() {
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.usbhost ${D}${sysconfdir}/init.d/usbhost
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
