HOMEPAGE = "https://github.com/Cloudef/libpndman"
DESCRIPTION  = "Package managment library for PND files."

LICENSE  = "WTFPL"
LIC_FILES_CHKSUM = "file://COPYING;md5=8365d07beeb5f39d87e846dca3ae7b64"

DEPENDS  = "jansson bzip2 expat openssl curl"
PR = "r2"

SRCREV = "8ff3d17fee1ea76df3b41c8b567cba2095c98db7"
inherit cmake

SRC_URI = "git://github.com/Cloudef/libpndman.git;protocol=git \
          "
S = "${WORKDIR}/git"

PV = "1.0.0"

PACKAGE_ARCH = "${MACHINE_ARCH}"
