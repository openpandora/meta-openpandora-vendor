DESCRIPTION = "A small program that shows the ps listing as a tree"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PR="r0"

SRC_URI = "ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-${PV}.tar.gz"

SRC_URI[md5sum] = "a97ebb878b3e093107afa9d0ddc1b6bd"
SRC_URI[sha256sum] = "9d05d28432a12fe8744b895e10b4a39008bba4fc3787b3595da3cf599b75a4ef"

do_compile() {
	${CC} -O -o pstree ../pstree.c
}


