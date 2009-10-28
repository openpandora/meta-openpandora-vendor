DESCRIPTION="Simple Login Manager"
HOMEPAGE="http://slim.berlios.de"
LICENSE = "GPL"

PR = "r1"

inherit update-rc.d

DEPEND="virtual/x11 libxmu libpng libjpeg libpam freetype"

RDEPEND="${DEPEND} perl xauth"
    
S = "${WORKDIR}/${PN}-${PV}/"

SRC_URI=" \
  http://download.berlios.de/${PN}/${P}.tar.gz \
  file://fix-manpage.patch;patch=1 \
#  file://slim-conf.patch;patch=1 \
  file://ftbfs_gcc_4.4.patch;patch=1 \
  file://Makefile.patch;patch=1 \
  file://xauth_secret_support.patch;patch=1 \
  file://delay.patch;patch=1 \  
  file://pam-unix2.patch;patch=1 \    
  file://rc.slim \
  file://slim-dynwm \
  file://update_slim_wmlist \
  file://Makefile.oe \  
  file://slim.pamd \
"

EXTRA_OEMAKE += " \
  USE_PAM=1 \
  PREFIX=${prefix} \
  CFGDIR=${sysconfdir} \
  MANDIR=${mandir} \
  DESTDIR=${D} \
  CFLAGS+=-I${STAGING_INCDIR}/freetype2 \
  CXXFLAGS+=-I${STAGING_INCDIR}/freetype2 \
  LDFLAGS+=-lXft \
  LDFLAGS+=-lX11 \
  LDFLAGS+=-lfreetype \
  LDFLAGS+=-lXrender \
  LDFLAGS+=-lfontconfig \
  LDFLAGS+=-lpng12 \
  LDFLAGS+=-lz \
  LDFLAGS+=-lm \
  LDFLAGS+=-lcrypt \
  LDFLAGS+=-lXmu \
  LDFLAGS+=-lpng \
  LDFLAGS+=-ljpeg \
  LDFLAGS+=-lrt \
  LDFLAGS+=-lpam \
"

#EXTRA_OEMAKE += "-I${STAGING_INCDIR}/freetype2"
#EXTRA_OEMAKE += 'EXTRA_CFLAGS="-I${STAGING_INCDIR}/freetype2"'

#do_compile_prepend() {
#  # respect C[XX]FLAGS, fix crosscompile,
#  # fix linking order for --as-needed"
#  sed -i -e "s:^CXX=.*:CXX=$(CXX) ${CXXFLAGS}:" \
#    -e "s:^CC=.*:CC=$(CC) ${CFLAGS}:" \
#    -e "s:^MANDIR=.*:MANDIR=/usr/share/man:" \
#    -e "s:^\t\(.*\)\ \$(LDFLAGS)\ \(.*\):\t\1\ \2\ \$(LDFLAGS):g" \
#    -r -e "s:^LDFLAGS=(.*):LDFLAGS=\1 ${LDFLAGS}:" \
#    Makefile"
#}

do_compile_prepend() {
  cp -pP ${WORKDIR}/Makefile.oe ${S}/Makefile
}

#  USE_PAM=1 ARCH=${TARGET_ARCH} CROSS_COMPILE=${TARGET_PREFIX} CC=${TARGET_CC} \
#               CXX=${TARGET_CXX} DESTDIR=${D} MANDIR=${mandir} PREFIX=${prefix} CFGDIR=${sysconfdir}

do_install() {
  oe_runmake install 
  install -d ${D}${bindir}
  install -m 0755 ${WORKDIR}/slim-dynwm ${D}${bindir}/
  install -m 0755 ${WORKDIR}/update_slim_wmlist ${D}${bindir}/
  install -d ${D}${sysconfdir}/pam.d/  
  install -m 0644 ${WORKDIR}/slim.pamd ${D}${sysconfdir}/pam.d/slim
  install -d ${D}${sysconfdir}/init.d/
  cp -pP ${WORKDIR}/rc.slim ${D}${sysconfdir}/init.d/slim-init
}

INITSCRIPT_NAME = "slim-init"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 20 0 1 6 ."

pkg_postinst_${PN} () {
# Register SLiM as default DM
mkdir -p ${sysconfdir}/X11/
echo "${bindir}/slim-dynwm" > ${sysconfdir}/X11/default-display-manager
}

pkg_postrm_${PN} () {
sed -i /slim-dynwm/d ${sysconfdir}/X11/default-display-manager || true
}
