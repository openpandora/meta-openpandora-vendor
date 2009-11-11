DESCRIPTION = "Scripts to support system options on the OpenPandora."
LICENSE = "GPLV2"

COMPATIBLE_MACHINE = "omap3-pandora"

PR = "r2"

SRC_URI = " \
          file://op_bright.sh \
          file://op_bright.desktop \
          file://op_cpuspeed.sh \
          file://op_cpuspeed.desktop \          
"

do_install() {
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_bright.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_cpuspeed.sh ${D}${prefix}/pandora/scripts/          
          install -d ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_bright.desktop ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_cpuspeed.desktop ${D}${datadir}/applications/          
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"