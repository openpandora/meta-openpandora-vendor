DESCRIPTION = "Default 'new user' files on the OpenPandora."

COMPATIBLE_MACHINE = "openpandora"

PR = "r1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=956931f56ef227f7d172a149ddb40b48"

SRC_URI = " \
  file://LICENSE \
  file://openpandora.conf \
"

do_install() {

install -d ${D}${sysconfdir}/modules-load.d
install -m 0755 ${WORKDIR}/openpandora.conf ${D}${sysconfdir}/modules-load.d/openpandora.conf

}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} = "/*"
