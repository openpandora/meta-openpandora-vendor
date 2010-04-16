DESCRIPTION = "Miscellaneous OpenPandora utilities"

PR = "r0"

PARALLEL_MAKE = ""

DEPENDS = "virtual/libx11"

SRC_URI = " \
          git://openpandora.org/pandora-misc.git;protocol=git;branch=master \
"

TARGET_LDFLAGS += "-lpthread -lX11"

SRCREV = "ef1736dc4fa9679f76f795bbef6139e3ea96797e"

S = "${WORKDIR}/git"

do_install() {
          install -d ${D}${bindir}/
          install -m 0755 ${S}/op_runfbapp ${D}${bindir}/op_runfbapp
          install -m 0755 ${S}/op_gammatool ${D}${bindir}/op_gammatool_bin 
          install -m 0755 ${S}/scripts/op_gammatool ${D}${bindir}/op_gammatool
}