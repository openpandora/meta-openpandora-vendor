DESCRIPTION = "Default OpenPandora settings for the Midori web browser"
HOMEPAGE = "http://www.openpandora.org"

PR = "r1"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

# This 'sort of' depends on the other SKEL templates.
RDEPENDS = "pandora-skel"

SRC_URI = " \
  file://accels \
  file://config \
  file://session.xbel \
  file://speeddial.json \
  file://bookmarks.xbel \
"

do_install() {  
  install -d ${D}${sysconfdir}/skel/
  install -d ${D}${sysconfdir}/skel/Applications/
  install -d ${D}${sysconfdir}/skel/Applications/Settings/
  install -d ${D}${sysconfdir}/skel/Applications/Settings/midori/

  install -m 0644 ${WORKDIR}/accels ${D}${sysconfdir}/skel/Applications/Settings/midori/accels
  install -m 0644 ${WORKDIR}/config ${D}${sysconfdir}/skel/Applications/Settings/midori/config
  install -m 0644 ${WORKDIR}/session.xbel ${D}${sysconfdir}/skel/Applications/Settings/midori/session.xbel
  install -m 0644 ${WORKDIR}/speeddial.json ${D}${sysconfdir}/skel/Applications/Settings/midori/speeddial.json
  install -m 0644 ${WORKDIR}/bookmarks.xbel ${D}${sysconfdir}/skel/Applications/Settings/midori/bookmarks.xbel  
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${sysconfdir}"

