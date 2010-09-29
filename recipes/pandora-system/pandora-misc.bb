DESCRIPTION = "Miscellaneous OpenPandora utilities"

PR = "r7"

PARALLEL_MAKE = ""

DEPENDS = "virtual/libx11 tslib"

SRC_URI = " \
          git://openpandora.org/pandora-misc.git;protocol=git;branch=master \
"

TARGET_LDFLAGS += "-lpthread -lX11 -lts"

SRCREV = "6b90ba471f52a5e5ff327e0b0f0338d4d7c62dc8"

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