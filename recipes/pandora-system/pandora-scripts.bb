DESCRIPTION = "Scripts to support system options on the OpenPandora."
LICENSE = "GPLV2"
RDEPENDS = "zenity dbus"

COMPATIBLE_MACHINE = "omap3-pandora"

PR = "r0"

SRC_URI = " \
          file://pnd_bright.sh \
          file://pnd_bright.desktop \
"

do_install() {
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${S}/pnd_bright.sh ${D}${prefix}/pandora/scripts/
          install -d ${D}${datadir}/applications/
          install -m 0644 ${S}/pnd_bright.desktop ${D}${datadir}/applications/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
