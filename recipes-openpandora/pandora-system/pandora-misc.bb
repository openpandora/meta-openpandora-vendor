DESCRIPTION = "Miscellaneous OpenPandora utilities"

PR = "r9"
LICENSE = "GPL"

PARALLEL_MAKE = ""
LICENSE = "GPLV2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

DEPENDS = "virtual/libx11 tslib"

SRC_URI = " \
          file://LICENSE \
          git://openpandora.org/pandora-misc.git;protocol=git;branch=master \
"

TARGET_LDFLAGS += "-lpthread -lX11 -lts"

#SRCREV = "51cdefeeb6c7d48c858689f0f7868b31039725b3"
SRCREV = "3f6f7d2fe4161d7b3e310deb825bc6409b1b60e1"

S = "${WORKDIR}/git"

do_compile() {
    ${CC} -Wl,--hash-style=gnu op_runfbapp.c -lX11 -lpthread -o op_runfbapp
    ${CC} -Wl,--hash-style=gnu op_gammatool.c -o op_gammatool
    ${CC} -Wl,--hash-style=gnu op_test_inputs.c -lts -lpthread -o op_test_inputs
    ${CC} -Wl,--hash-style=gnu ofbset.c -o ofbset  
}

do_install() {
          install -d ${D}${bindir}/
          install -m 0755 ${S}/op_runfbapp ${D}${bindir}/op_runfbapp
          install -m 0755 ${S}/op_gammatool ${D}${bindir}/op_gammatool_bin 
          install -m 0755 ${S}/op_test_inputs ${D}${bindir}/op_test_inputs_bin 
          install -m 0755 ${S}/ofbset ${D}${bindir}/ofbset           
          install -m 0755 ${S}/scripts/op_gammatool ${D}${bindir}/op_gammatool
          install -m 0755 ${S}/scripts/op_test_inputs ${D}${bindir}/op_test_inputs
}
