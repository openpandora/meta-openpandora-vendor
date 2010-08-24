DESCRIPTION = "Custom sudoers files for the OpenPandora."
LICENSE = "GPLV2"

COMPATIBLE_MACHINE = "omap3-pandora"

RDEPENDS = "sudo"

PR = "r8"

SRC_URI = " \
          file://50_openpandora \
"

do_install() {
          install -d ${D}${sysconfdir}/sudoers.d/
          install -m 440 ${WORKDIR}/50_openpandora ${D}${sysconfdir}/sudoers.d/50_openpandora
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
