DESCRIPTION = "Report the OMAP3 SoC unique ID"
LICENSE = "GPL"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"
PR ="r1"

inherit autotools

PACKAGE_ARCH_omap3-pandora = "${MACHINE_ARCH}"

SRC_URI = "file://mem.c \
           file://omap3-deviceid.sh \
           file://Makefile"

S="${WORKDIR}"

TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/mem ${D}${bindir}
	install -m 0755 ${WORKDIR}/omap3-deviceid.sh ${D}${bindir}
}

FILES_${PN} = "/usr/bin/mem /usr/bin/omap3-deviceid.sh"
