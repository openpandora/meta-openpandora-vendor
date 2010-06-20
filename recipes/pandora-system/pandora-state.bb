DESCRIPTION = "Save and restore some specific Pandora settings on shutdown / startup"
LICENSE = "GPLv2"

COMPATIBLE_MACHINE = "omap3-pandora"

PR = "r5"
inherit update-rc.d

INITSCRIPT_NAME = "pandora-state"
INITSCRIPT_PARAMS = "start 39 S . stop 31 0 1 6 ."

SRC_URI = " \
          file://rc.pandora-lcd-state \
	  file://gamma.state \
	  file://brightness.state \
	  file://nubs.state \
	  file://dirty_expire_centisecs \
"

do_install() {
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.pandora-state ${D}${sysconfdir}/init.d/pandora-state
	  install -d ${D}${sysconfdir}/pandora/conf/
          install -m 0644 ${WORKDIR}/gamma.state ${D}${sysconfdir}/pandora/conf/gamma.state
          install -m 0644 ${WORKDIR}/brightness.state ${D}${sysconfdir}/pandora/conf/brightness.state
	  install -m 0644 ${WORKDIR}/nubs.state ${D}${sysconfdir}/pandora/conf/nubs.state
	  install -m 0644 ${WORKDIR}/dirty_expire_centisecs ${D}${sysconfdir}/pandora/conf/dirty_expire_centisecs
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
