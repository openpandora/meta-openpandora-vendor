DESCRIPTION = "Support for the PND format in Pandora images (lib, daemon, init script etc.)"
LICENSE = "lGPL"

PR = "r5"

PARALLEL_MAKE = ""

SRC_URI = " \
          git://openpandora.org/pandora-libraries.git;protocol=git;branch=master \
          file://rc.libpnd \
"

SRCREV = "fd9090900d653b51b1d7b335b1224c3b65353773"

S = "${WORKDIR}/git"

inherit update-rc.d

TARGET_CC_ARCH += "${LDFLAGS}"
TARGET_CFLAGS += "-Wall -I./include"

INITSCRIPT_NAME = "libpnd-init"
INITSCRIPT_PARAMS = "start 30 5 2 . stop 40 0 1 6 ."

do_compile_prepend() {
          cd ${S}/
}

do_compile() {
          oe_runmake 
          oe_runmake deploy
}

do_install() {
          install -d ${D}${sysconfdir}/pandora/conf/
          install ${S}/deployment/etc/pandora/conf/apps ${D}${sysconfdir}/pandora/conf/apps
          install ${S}/deployment/etc/pandora/conf/desktop ${D}${sysconfdir}/pandora/conf/desktop
          install ${S}/deployment/etc/pandora/conf/categories ${D}${sysconfdir}/pandora/conf/categories
          install -d ${D}${libdir}/
          cp -pP ${S}/deployment/usr/lib/libpnd* ${D}${libdir}/
          cp -pP ${S}/deployment/usr/lib/libpnd.so.1.0.1 ${D}${libdir}/libpnd.so.1

          install -d ${D}${bindir}/
          cp -pP ${S}/deployment/usr/bin/pndnotifyd ${D}${bindir}/pndnotifyd
                   
          install -d ${D}${prefix}/pandora/
          install -d ${D}${prefix}/pandora/apps/
          cp -pP ${S}/deployment/usr/pandora/apps/* ${D}${prefix}/pandora/apps
          install -d ${D}${prefix}/pandora/scripts/
          cp -pP ${S}/deployment/usr/pandora/scripts/* ${D}${prefix}/pandora/scripts
          
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.libpnd ${D}${sysconfdir}/init.d/libpnd-init
          
          install -d ${D}${prefix}/local/share/applications/
}

FILES_${PN} += "${bindir} ${sbindir} ${prefix}/pandora/*"
FILES_${PN}-dev += "${libdir}/libpnd.a"
