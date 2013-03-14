DESCRIPTION = "7-Zip is a file archiver with highest compression ratio."
LICENSE = "lGPL"
LIC_FILES_CHKSUM = "file://DOCS/copying.txt;md5=ecfc54c9e37b63ac58900061ce2eab5a"

PR = "r1"

SRC_URI = " \
          http://sourceforge.net/projects/p7zip/files/p7zip/9.20.1/p7zip_9.20.1_src_all.tar.bz2 \
	file://makefile.machine \
"

SRC_URI[md5sum] = "bd6caaea567dc0d995c990c5cc883c89"
SRC_URI[sha256sum] = "49557e7ffca08100f9fc687f4dfc5aea703ca207640c76d9dee7b66f03cb4782"

S = "${WORKDIR}/p7zip_9.20.1"

do_configure_append () {
	cp ${WORKDIR}/makefile.machine ${S}/
}

