DESCRIPTION = "Scripts to support the first run wizard on the OpenPandora."
LICENSE = "GPLV2"
RDEPENDS = "pandora-auto-startx zenity dbus"

# Based on the scripts by JohnX/Mer Project - http://wiki.maemo.org/Mer/

COMPATIBLE_MACHINE = "omap3-pandora"

PR = "r0.3"

SRC_URI = " \
          file://first-boot-wizard.sh \
"

do_install() {         
          install -d ${D}${sbindir}
          cp -pP ${WORKDIR}/first-boot-wizard.sh ${D}${sbindir}/first-boot-wizard.sh
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "/lib/firmware"
