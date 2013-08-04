DESCRIPTION = "Scripts to support the first run wizard on the OpenPandora."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

DEPENDS = "hsetroot zenity dbus"
RDEPENDS_${PN} = "hsetroot zenity dbus openpandora-wallpaper-official tslib tslib-calibrate openpandora-skel xmodmap openpandora-scripts \
                  tzdata-africa tzdata-americas tzdata-asia tzdata-australia tzdata-europe tzdata-pacific \
"

COMPATIBLE_MACHINE = "openpandora"

PR = "r48"
PRINC := "${@int(PRINC) + 1}"

SRC_URI = " \
          file://LICENSE \
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
