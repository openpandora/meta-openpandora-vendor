DESCRIPTION = "Miscellaneous OpenPandora utilities"

PR = "r15"

PARALLEL_MAKE = ""
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "openpandora"

DEPENDS = "virtual/libx11 tslib"

SRC_URI = " \
          file://LICENSE \
          git://openpandora.org/pandora-misc.git;protocol=git;branch=master \
"

TARGET_LDFLAGS += "-lpthread -lX11 -lts"

SRCREV = "7f0df40a68cbd7f4b319bf334f16e2c3c344dc59"

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
