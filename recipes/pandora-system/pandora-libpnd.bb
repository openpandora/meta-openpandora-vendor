DESCRIPTION = "Support for the PND format in Pandora images (lib, daemon, init script etc.)"
LICENSE = "lGPL"

PR = "r1"

SRC_URI = " \
          git://openpandora.org/pandora-libraries.git;protocol=git;branch=master \
"

SRCREV = "886aeeeba3b074ebb92be3d9ac1d961a156163a9"

S = "${WORKDIR}/git"


SRC_URI += " \
#	file://wlan_cu_makefile.patch;patch=1 \
"

do_compile_prepend() {
	cd ${S}/
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/wlan_cu ${D}${bindir}
#	install -m 0755 ${S}/tiwlan_loader ${D}${bindir}
}

FILES_${PN} += "${bindir} ${sbindir} ${bindir}/wlan_cu ${bindir}/tiwlan_loader"
