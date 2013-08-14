DESCRIPTION = "Scripts to support system options on the OpenPandora."
LICENSE = "GPLV2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

COMPATIBLE_MACHINE = "openpandora"

RDEPENDS = "openpandora-scripts"

PR = "r2"

SRC_URI = " \
          file://LICENSE \
          file://op_wifi.sh \
          file://op_wifi.pnd \  
          file://nettool.pnd \
          file://op_bluetooth.sh \
          file://op_bluetooth_work.sh \
          file://op_bluetooth-check.desktop \
          file://op_bluetooth.desktop \          
"

do_install() {
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_wifi.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_bluetooth.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_bluetooth_work.sh ${D}${prefix}/pandora/scripts/

          install -d ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_wifi.pnd ${D}${prefix}/pandora/apps/

	  install -d ${D}${prefix}/pandora/mmenu/
	  install -m 0755 ${WORKDIR}/nettool.pnd ${D}${prefix}/pandora/mmenu/
	  
	  install -d ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_bluetooth.desktop ${D}${datadir}/applications/
          
          install -d ${D}${sysconfdir}/xdg/autostart/
          install -m 0644 ${WORKDIR}/op_bluetooth-check.desktop ${D}${sysconfdir}/xdg/autostart/op_bluetooth-check.desktop
	  
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
