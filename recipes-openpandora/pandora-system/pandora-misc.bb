DESCRIPTION = "Miscellaneous OpenPandora utilities"

PR = "r8"
LICENSE = "GPL"

PARALLEL_MAKE = ""

DEPENDS = "virtual/libx11 tslib"

SRC_URI = " \
          git://openpandora.org/pandora-misc.git;protocol=git;branch=master \
"

TARGET_LDFLAGS += "-lpthread -lX11 -lts"

SRCREV = "51cdefeeb6c7d48c858689f0f7868b31039725b3"

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