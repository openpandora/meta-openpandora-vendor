DESCRIPTION = "Custom sudoers files for the OpenPandora."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

COMPATIBLE_MACHINE = "openpandora"

RDEPENDS_${PN} = "sudo"

PR = "r22"

SRC_URI = " \
          file://LICENSE \
          file://50_openpandora \
"

do_install() {
          install -d ${D}${sysconfdir}/sudoers.d/
          install -m 440 ${WORKDIR}/50_openpandora ${D}${sysconfdir}/sudoers.d/50_openpandora
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
