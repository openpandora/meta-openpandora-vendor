SECTION = "console/network"
DESCRIPTION = "framebuffer screenshot program"
LICENSE = "GPL"
LIC_FILES_CHKSUM = "file://COPYING;md5=ea5bed2f60d357618ca161ad539f7c0a"

PR = "r2"

DEPENDS = " zlib libpng "

SRC_URI = "http://hem.bredband.net/gmogmo/fbgrab/fbgrab-${PV}.tar.gz \
           file://makefile.patch;patch=1 \
	   http://people.openezx.org/ao2/fbgrab_network_mode.diff;patch=1 \
	   file://fbgrab_1bpp.patch;patch=1 \
	   "

do_install() {
	install -d ${D}${bindir} ${D}${mandir}/man1/
	install -m 0755 fbgrab ${D}${bindir}
	install -m 0644 fbgrab.1.man ${D}${mandir}/man1/fbgrab.1
}
