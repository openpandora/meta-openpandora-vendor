DESCRIPTION = "Save and restore some specific Pandora settings on shutdown / startup"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

COMPATIBLE_MACHINE = "openpandora"

RDEPENDS_${PN} = "openpandora-scripts"

PR = "r18"

#.next modification
PRINC := "${@int(PRINC) + 1}"

inherit systemd

#inherit update-rc.d

#INITSCRIPT_NAME = "pandora-state"
#INITSCRIPT_PARAMS = "start 39 S . stop 31 0 1 6 ."
	   
SRC_URI = " \
	  file://LICENSE \
	  file://gamma.state \
	  file://dssgamma.state \
	  file://brightness.state \
	  file://nubs.state \
	  file://dirty_expire_centisecs \
	  file://rc.pandora-state \
	  file://pandora-state.service \
"

#          install -d ${D}${sysconfdir}/init.d/
#          install -m 0755 ${WORKDIR}/rc.pandora-state ${D}${sysconfdir}/init.d/pandora-state

do_install() {
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/rc.pandora-state ${D}${prefix}/pandora/scripts/pandora-state
	  install -d ${D}${sysconfdir}/pandora/conf/
          install -m 0644 ${WORKDIR}/gamma.state ${D}${sysconfdir}/pandora/conf/gamma.state
	  install -m 0644 ${WORKDIR}/dssgamma.state ${D}${sysconfdir}/pandora/conf/dssgamma.state
          install -m 0644 ${WORKDIR}/brightness.state ${D}${sysconfdir}/pandora/conf/brightness.state
	  install -m 0644 ${WORKDIR}/nubs.state ${D}${sysconfdir}/pandora/conf/nubs.state
	  install -m 0644 ${WORKDIR}/dirty_expire_centisecs ${D}${sysconfdir}/pandora/conf/dirty_expire_centisecs
      install -d ${D}/${base_libdir}/systemd/system
      install -m 0644 ${WORKDIR}/pandora-state.service ${D}/${base_libdir}/systemd/system/pandora-state.service
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "pandora-state.service"
