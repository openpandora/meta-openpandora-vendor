DESCRIPTION = "Default OpenPandora settings and skin for XMMS"
HOMEPAGE = "http://www.openpandora.org"

PR = "r1"

# This 'sort of ' depends on the other SKEL templates.
RDEPENDS = "pandora-skel"

SRC_URI = " \
  file://UltraClean_Original.tar.gz.leavemealone \
  file://xmmsconfig \
  file://menurc \
"

do_install() {  
  install -d ${D}${datadir}/xmms/
  install -d ${D}${datadir}/xmms/skins/
  install -m 0644 ${WORKDIR}/UltraClean_Original.tar.gz.leavemealone ${D}${datadir}/xmms/skins/UltraClean_Original.tar.gz 

  install -d ${D}${sysconfdir}/skel/
  install -d ${D}${sysconfdir}/skel/.xmms/
  install -m 0644 ${WORKDIR}/xmmsconfig ${D}${sysconfdir}/skel/.xmms/config
  install -m 0644 ${WORKDIR}/menurc ${D}${sysconfdir}/skel/.xmms/menurc
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${datadir} ${sysconfdir}"
