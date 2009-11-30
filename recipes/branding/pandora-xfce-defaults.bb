DESCRIPTION = "Default OpenPandora settings for Xfce4"
HOMEPAGE = "http://www.openpandora.org"
SECTION = "x11/xfce"

PR = "r4"

SRC_URI = " \
  file://xfce4-conf.zip \
  file://pixmaps/* \
"

do_install() {  
  install -d ${D}${datadir}/pixmaps/
  install -m 0644 ${WORKDIR}/pixmaps/* ${D}${datadir}/pixmaps/

  install -d ${D}${sysconfdir}/xdg/op/xfce4/

  install -d ${D}${sysconfdir}/xdg/op/xfce4/panel/
  install -m 0666 ${WORKDIR}/xfce4/panel/* ${D}${sysconfdir}/xdg/op/xfce4/panel/
  
  install -d ${D}${sysconfdir}/xdg/op/xfce4/xfconf/xfce-perchannel-xml/
  install -m 0666 ${WORKDIR}/xfce4/xfconf/xfce-perchannel-xml/* ${D}${sysconfdir}/xdg/op/xfce4/xfconf/xfce-perchannel-xml/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${datadir} ${sysconfdir}"
