DESCRIPTION="Simple Login Manager"
HOMEPAGE="http://slim.berlios.de"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=8ca43cbc842c2336e835926c2166c28b"

PR = "r1"

DEPENDS = "virtual/libx11 libxmu libpng jpeg freetype sessreg ${@base_contains('DISTRO_FEATURES', 'pam', 'libpam', '', d)}"

SRC_URI = " \
  http://download.berlios.de/${PN}/${P}.tar.gz \
  file://slim-dynwm \
  file://update_slim_wmlist \
  file://Makefile.oe \
  file://slim.pamd \
  file://slim.service \
"

SRC_URI[md5sum] = "1153e6993f9c9333e4cf745411d03472"
SRC_URI[sha256sum] = "818d209f51e2fa8d5b94ef75ce90a7415be48b45e796d66f8083a9532b655629"


EXTRA_OEMAKE += " \
  USE_PAM=${@base_contains('DISTRO_FEATURES', 'pam', '1', '0', d)} \
  PREFIX=${prefix} \
  CFGDIR=${sysconfdir} \
  MANDIR=${mandir} \
  DESTDIR=${D} \
  CFLAGS+=-I${STAGING_INCDIR}/freetype2 \
  CXXFLAGS+=-I${STAGING_INCDIR}/freetype2 \
"

do_compile_prepend() {
  cp -pP ${WORKDIR}/Makefile.oe ${S}/Makefile
}

do_install() {
  oe_runmake install
  install -d ${D}${bindir}
  install -m 0755 ${WORKDIR}/slim-dynwm ${D}${bindir}/
  install -m 0755 ${WORKDIR}/update_slim_wmlist ${D}${bindir}/
  install -d ${D}${sysconfdir}/pam.d/
  install -m 0644 ${WORKDIR}/slim.pamd ${D}${sysconfdir}/pam.d/slim

  install -d ${D}${systemd_unitdir}/system/
  install -m 0644 ${WORKDIR}/*.service ${D}${systemd_unitdir}/system/

  echo 'sessionstart_cmd    /usr/bin/sessreg -a -l $DISPLAY %user' >> ${D}${sysconfdir}/slim.conf
  echo 'sessionstop_cmd     /usr/bin/sessreg -d -l $DISPLAY %user' >> ${D}${sysconfdir}/slim.conf
}


RDEPENDS_${PN} = "perl xauth freetype sessreg "
FILES_${PN} += "${systemd_unitdir}/system/"

pkg_postinst_${PN} () {
if test "x$D" != "x"; then
	exit 1
fi
systemctl enable slim.service

# Register SLiM as default DM
mkdir -p ${sysconfdir}/X11/
echo "${bindir}/slim" > ${sysconfdir}/X11/default-display-manager
}

pkg_postrm_${PN} () {
if test "x$D" != "x"; then
	exit 1
fi
systemctl disable slim.service
sed -i /slim/d $D${sysconfdir}/X11/default-display-manager || true
}

