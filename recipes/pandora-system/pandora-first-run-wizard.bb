DESCRIPTION = "Scripts to support the first run wizard on the OpenPandora."
LICENSE = "GPLV2"
RDEPENDS = "hsetroot zenity dbus"

COMPATIBLE_MACHINE = "omap3-pandora"

PR = "r2"

SRC_URI = " \
          file://first-run-wizard.sh \
          file://rc.firstrun \
          file://op_default.png \          
"

inherit update-rc.d

INITSCRIPT_NAME = "oprun-init"
INITSCRIPT_PARAMS = "start 29 2 3 4 5 . stop  29 2 3 4 5 ."

do_install() {         
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/first-run-wizard.sh ${D}${prefix}/pandora/scripts/
          
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.firstrun ${D}${sysconfdir}/init.d/oprun-init
          
          install -d ${D}${datadir}/backgrounds/
          install -m 0644 ${WORKDIR}/op_default.png ${D}${datadir}/backgrounds/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${sysconfdir}"
