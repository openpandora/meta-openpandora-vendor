DESCRIPTION = "Matchbox window manager theme for the Pandora"
LICENSE = "GPL"
DEPENDS = "matchbox-wm"
SECTION = "x11/wm"

PV = "0.1"
PR = "r0"

PACKAGE_ARCH = "all"

#GIT HEAD
SRCREV = 1bd11ea0a6bacafe216bbb29492e064fc52979b0

SRC_URI = " \
	git://git.openpandora.org/pandora-libraries.git;protocol=git;branch=master \
"

S = "${WORKDIR}/git"

do_install() {
	find ${WORKDIR} -name ".git" | xargs rm -rf
	install -d ${D}${datadir}/themes/pandora-standard/gtk-2.0
	cp -fpPR ${S}/* ${D}${datadir}/themes/pandora-standard/
	rm -rf ${D}${datadir}/themes/pandora-standard/patches/
	
	install -d ${D}${sysconfdir}/gtk-2.0
	echo 'include "${datadir}/themes/openmoko-standard-2/gtk-2.0/gtkrc"' >> ${D}${sysconfdir}/gtk-2.0/gtkrc
}

CONFFILES_${PN} = "${sysconfdir}/gtk-2.0/gtkrc"

PACKAGE_ARCH = "all"
FILES_${PN} = "${datadir} ${sysconfdir}"
