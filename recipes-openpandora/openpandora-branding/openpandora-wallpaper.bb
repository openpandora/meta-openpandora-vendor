DESCRIPTION = "Wallpapers created by the community for the OpenPandora, thanks go to the community for the graphics"

PR = "r2"
LICENSE = "GPL"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = " \
  file://LICENSE \  
  file://community/* \
  file://official/* \
"

PACKAGES = "${PN}-community ${PN}-official"

do_install() {         
  install -d ${D}${datadir}/xfce4/backdrops/
  install -m 0644 ${WORKDIR}/community/* ${D}${datadir}/xfce4/backdrops/
  install -m 0644 ${WORKDIR}/official/* ${D}${datadir}/xfce4/backdrops/
}


PACKAGE_ARCH = "all"

FILES_${PN}-community = "${datadir}/xfce4/backdrops/community*"
FILES_${PN}-official = "${datadir}/xfce4/backdrops/op*"
