DESCRIPTION = "7-Zip is a file archiver with highest compression ratio."
LICENSE = "lGPL"
LIC_FILES_CHKSUM = "file://DOCS/copying.txt;md5=ecfc54c9e37b63ac58900061ce2eab5a"

PR = "r1"

SRC_URI = " \
        http://sourceforge.net/projects/p7zip/files/p7zip/${PV}/p7zip_${PV}_src_all.tar.bz2 \
	file://makefile.machine \
	file://7z \
"

SRC_URI[md5sum] = "bd6caaea567dc0d995c990c5cc883c89"
SRC_URI[sha256sum] = "49557e7ffca08100f9fc687f4dfc5aea703ca207640c76d9dee7b66f03cb4782"

S = "${WORKDIR}/p7zip_${PV}"
  
        
do_compile() {
	cp ${WORKDIR}/makefile.machine ${S}/
	echo CC=${TARGET_PREFIX}gcc ${TARGET_CC_ARCH} --sysroot=\$\(PKG_CONFIG_SYSROOT_DIR\) \$\(ALLFLAGS\) >> ${S}/makefile.machine
	echo CXX=${TARGET_PREFIX}g++ ${TARGET_CC_ARCH} --sysroot=\$\(PKG_CONFIG_SYSROOT_DIR\) \$\(ALLFLAGS\) >> ${S}/makefile.machine
        make -j4 7z
}

do_install() {
        install -d -m 0755 ${D}${bindir}
        install -m 0755 ${WORKDIR}/7z ${D}${bindir}
        install -d -m 0755 ${D}${libdir}/p7zip
        install -m 0755 ${S}/bin/7z  ${D}${libdir}/p7zip/
        install -m 0755 ${S}/bin/7z.so ${D}${libdir}/p7zip/      
}
