DESCRIPTION = "Save and restore the brightness and gamma state on shutdown / startup"
LICENSE = "GPLv2"

COMPATIBLE_MACHINE = "omap3-pandora"

PR = "r4"
inherit update-rc.d

INITSCRIPT_NAME = "pandora-lcd-state"
INITSCRIPT_PARAMS = "start 39 S . stop 31 0 1 6 ."

SRC_URI = " \
          file://rc.pandora-lcd-state \
	  file://gamma.state \
	  file://brightness.state \
	  file://nubs.state \
"

do_install() {
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.pandora-lcd-state ${D}${sysconfdir}/init.d/pandora-lcd-state
	  install -d ${D}${sysconfdir}/pandora/conf/
          install -m 0644 ${WORKDIR}/gamma.state ${D}${sysconfdir}/pandora/conf/gamma.state
          install -m 0644 ${WORKDIR}/brightness.state ${D}${sysconfdir}/pandora/conf/brightness.state
	  install -m 0644 ${WORKDIR}/nubs.state ${D}${sysconfdir}/pandora/conf/nubs.state
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
