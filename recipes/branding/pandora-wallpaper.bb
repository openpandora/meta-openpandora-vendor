DESCRIPTION = "Wallpapers created by the community for the OpenPandora, thanks go to the community for the graphics"

PR = "r0"

SRC_URI = " \
  file://community/* \
  file://official/* \
"

PACKAGES = "${PN}-community ${PN}-official"

do_install() {         
  install -d ${D}${prefix}/xfce4/backdrops/
  install -m 0644 ${WORKDIR}/community/* ${D}${prefix}/xfce4/backdrops/
  install -m 0644 ${WORKDIR}/official/* ${D}${prefix}/xfce4/backdrops/
}


PACKAGE_ARCH = "all"

FILES_${PN}-community = "${prefix}/xfce4/backdrops/community*"
FILES_${PN}-official = "${prefix}/xfce4/backdrops/op*"
