HOMEPAGE = "https://github.com/bzar/panorama"
DESCRIPTION  = "application launcher written in Qt for the OpenPandora portable gaming platform."

LICENSE  = "CC BY-SA 3.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f582cca373ecede34c7ddbb0e13b388e"

do_sync_submodules() {
	git submodule update --init
}

addtask sync_submodules before do_patch after do_unpack

DEPENDS  = "jansson bzip2 expat openssl curl"
PR = "r1"

SRCREV = "7bf9efc4b04f03af4e85869173bdb3b21df691a9"
inherit cmake

SRC_URI = "git://github.com/bzar/panorama.git;protocol=git \
          "
S = "${WORKDIR}/git"

PV = "1.0.0"

PACKAGE_ARCH = "${MACHINE_ARCH}"
