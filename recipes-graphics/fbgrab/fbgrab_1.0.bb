SECTION = "console/network"
DESCRIPTION = "framebuffer screenshot program"
LICENSE = "GPL"
LIC_FILES_CHKSUM = "file://COPYING;md5=ea5bed2f60d357618ca161ad539f7c0a"

PR = "r2"

DEPENDS = " zlib libpng "

SRC_URI = "git://github.com/notespace/fbgrab.git"
SRCREV = "cee7102f8cc560cf46798a32e823c6bb65e3b50f"
S = "${WORKDIR}/git"

inherit autotools

#SRC_URI[md5sum] = "7af4d8774684182ed690d5da82d6d234"
#SRC_URI[sha256sum] = "9158241a20978dcc4caf0692684da9dd3640fd6f5c8b72581bd099198d670510"

#SRC_URI = "http://hem.bredband.net/gmogmo/fbgrab/fbgrab-${PV}.tar.gz \
#           file://makefile.patch;patch=1 \
#	   http://people.openezx.org/ao2/fbgrab_network_mode.diff;patch=1 \
#	   file://fbgrab_1bpp.patch;patch=1 \
#	   "

#do_install() {
#	install -d ${D}${bindir} ${D}${mandir}/man1/
#	install -m 0755 fbgrab ${D}${bindir}
#	install -m 0644 fbgrab.1.man ${D}${mandir}/man1/fbgrab.1
#}
