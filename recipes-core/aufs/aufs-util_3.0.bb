DESCRIPTION = "Userspace utilites for aufs3"
DEPENDS = "virtual/kernel"
PR = "r3"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=892f569a555ba9c07a568a7c0c4fa63a"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRCREV = "f86f9aa1474f51e07a26f14dfa0f8d24b79841cb"
SRC_URI = "git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git;branch=aufs3.0"

S = "${WORKDIR}/git"

CFLAGS_prepend = "-I${WORKDIR}/user_headers/include "

EXTRA_OEMAKE = "KDIR=${WORKDIR}/user_headers DESTDIR=${D} HOSTCC=${BUILD_CC}"

do_prepheaders() {
	# START MASSIVE 'MAYBE' HACK: 
	# Stage the userspace headers from our kernel WITH AUFS3 so we can use the tweaked userspace headers.
	cd ${STAGING_KERNEL_DIR}
	make headers_install INSTALL_HDR_PATH=${WORKDIR}/user_headers
	# STOP MASSIVE 'MAYBE'  HACK: 
}

addtask prepheaders after do_configure before do_compile

do_install () {
	install -d ${D}/${base_sbindir}
	install -m 0755 mount.aufs umount.aufs auplink ${D}/${base_sbindir}
	install -d ${D}/${base_bindir}
	install -m 0755 auchk aubrsync ${D}/${base_bindir}
	install -d ${D}/${sysconfdir}/default
	install -m 0644 -T etc_default_aufs ${D}/${sysconfdir}/default/aufs
}
