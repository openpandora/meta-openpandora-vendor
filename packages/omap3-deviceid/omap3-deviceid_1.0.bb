DESCRIPTION = "Report the OMAP3 SoC unique ID"
LICENSE = "GPL"
PR ="r2"

inherit autotools

PACKAGE_ARCH_omap3-pandora = "${MACHINE_ARCH}"

SRC_URI = "file://mem.c \
           file://omap3-deviceid.sh \
           file://Makefile"

S="${WORKDIR}"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/mem ${D}${bindir}
	install -m 0755 ${WORKDIR}/omap3-deviceid.sh ${D}${bindir}
}

FILES_${PN} = "/usr/bin/mem /usr/bin/omap3-deviceid.sh"
