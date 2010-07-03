DESCRIPTION = "Scripts to support the first run wizard on the OpenPandora."
LICENSE = "GPLV2"

DEPENDS = "hsetroot zenity dbus"
RDEPENDS = "hsetroot zenity dbus pandora-wallpaper-official tslib tslib-calibrate pandora-skel xmodmap"

COMPATIBLE_MACHINE = "omap3-pandora"

PR = "r16"

SRC_URI = " \
          file://first-run-wizard.sh \
          file://op_startup.sh \
          file://rc.firstrun \          
"

inherit update-rc.d

INITSCRIPT_NAME = "oprun-init"
INITSCRIPT_PARAMS = "start 29 2 3 4 5 . stop  29 2 3 4 5 ."

do_install() {         
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/first-run-wizard.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_startup.sh ${D}${prefix}/pandora/scripts/

          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.firstrun ${D}${sysconfdir}/init.d/oprun-init

          install -d ${D}${sysconfdir}/pandora/          
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${sysconfdir}"
