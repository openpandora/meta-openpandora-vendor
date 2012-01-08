DESCRIPTION = "Default OpenPandora settings for Xfce4"
HOMEPAGE = "http://www.openpandora.org"
SECTION = "x11/xfce"

PR = "r17"
LICENSE = "GPL"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = " \
  file://LICENSE \
  file://xfce4-conf.zip \
  file://pixmaps/* \
"

do_install() {  
  install -d ${D}${datadir}/pixmaps/
  install -m 0644 ${WORKDIR}/pixmaps/* ${D}${datadir}/pixmaps/

  install -d ${D}${sysconfdir}/xdg/op/applications/
  install -m 0666 ${WORKDIR}/applications/defaults.list ${D}${sysconfdir}/xdg/op/applications/
  
  install -d ${D}${sysconfdir}/xdg/op/menus/
  install -m 0666 ${WORKDIR}/menus/* ${D}${sysconfdir}/xdg/op/menus/
    
  install -d ${D}${sysconfdir}/xdg/op/xfce4/
  install -m 0666 ${WORKDIR}/xfce4/helpers.rc ${D}${sysconfdir}/xdg/op/xfce4/
  install -m 0666 ${WORKDIR}/xfce4/Xcursor.xrdb ${D}${sysconfdir}/xdg/op/xfce4/
  install -m 0666 ${WORKDIR}/xfce4/Xft.xrdb ${D}${sysconfdir}/xdg/op/xfce4/
  
  install -d ${D}${sysconfdir}/xdg/op/xfce4/panel/
  install -m 0666 ${WORKDIR}/xfce4/panel/* ${D}${sysconfdir}/xdg/op/xfce4/panel/
  
  install -d ${D}${sysconfdir}/xdg/op/xfce4/xfconf/xfce-perchannel-xml/
  install -m 0666 ${WORKDIR}/xfce4/xfconf/xfce-perchannel-xml/* ${D}${sysconfdir}/xdg/op/xfce4/xfconf/xfce-perchannel-xml/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${datadir} ${sysconfdir}"
