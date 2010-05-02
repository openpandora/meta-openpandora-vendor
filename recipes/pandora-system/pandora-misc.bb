DESCRIPTION = "Miscellaneous OpenPandora utilities"

PR = "r4"

PARALLEL_MAKE = ""

DEPENDS = "virtual/libx11 tslib"

SRC_URI = " \
          git://openpandora.org/pandora-misc.git;protocol=git;branch=master \
"

TARGET_LDFLAGS += "-lpthread -lX11 -lts"

SRCREV = "27058c48ecef47331a1f1683fb323ba51a8a5670"

S = "${WORKDIR}/git"

do_install() {
          install -d ${D}${bindir}/
          install -m 0755 ${S}/op_runfbapp ${D}${bindir}/op_runfbapp
          install -m 0755 ${S}/op_gammatool ${D}${bindir}/op_gammatool_bin 
          install -m 0755 ${S}/op_test_inputs ${D}${bindir}/op_test_inputs_bin 
          install -m 0755 ${S}/ofbset ${D}${bindir}/ofbset           
          install -m 0755 ${S}/scripts/op_gammatool ${D}${bindir}/op_gammatool
          install -m 0755 ${S}/scripts/op_test_inputs ${D}${bindir}/op_test_inputs
}