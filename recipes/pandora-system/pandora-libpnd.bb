DESCRIPTION = "Support for the PND format in Pandora images (lib, daemon, init script etc.)"
LICENSE = "lGPL"

PR = "r1.7"

PARALLEL_MAKE = ""

SRC_URI = " \
          git://openpandora.org/pandora-libraries.git;protocol=git;branch=master \
          file://rc.libpnd \
"

SRCREV = "b2d3c0871614632279192ef86e5affd75312f01b"

S = "${WORKDIR}/git"

inherit update-rc.d

TARGET_CC_ARCH += "${LDFLAGS}"
TARGET_CFLAGS += "-Wall -I./include"

INITSCRIPT_NAME = "libpnd-init"
INITSCRIPT_PARAMS = "start 30 5 2 . stop 40 0 1 6 ."

do_compile_prepend() {
          cd ${S}/
}

#EXTRA_OEMAKE = "all"

do_compile() {
          oe_runmake 
          oe_runmake deploy
}

do_install() {
          install -d ${D}${sysconfdir}/pandora/conf/
          install ${S}/deployment/etc/pandora/conf/apps ${D}${sysconfdir}/pandora/conf/apps
          install ${S}/deployment/etc/pandora/conf/desktop ${D}${sysconfdir}/pandora/conf/desktop

          install -d ${D}${libdir}/
          cp -pP ${S}/deployment/usr/lib/libpnd.so.1.0.1 ${D}${libdir}/libpnd.so.1.0.1
          cp -pP ${S}/deployment/usr/lib/libpnd.a ${D}${libdir}/libpnd.a
          
          install -d ${D}${bindir}/
          cp -pP ${S}/deployment/usr/bin/pndnotifyd ${D}${bindir}/pndnotifyd
                   
          install -d ${D}${prefix}/pandora/
          install -d ${D}${prefix}/pandora/apps/
          cp -pP ${S}/deployment/usr/pandora/apps/.* ${D}${prefix}/pandora/apps/
          install -d ${D}${prefix}/pandora/scripts/
          cp -pP ${S}/deployment/usr/pandora/scripts/*.* ${D}${prefix}/pandora/scripts/
          
          install -d ${D}${sysconfdir}/init.d/
          cp -pP ${WORKDIR}/rc.libpnd ${D}${sysconfdir}/init.d/libpnd-init
}

pkg_postinst() {
#!/bin/sh
ln -sf /usr/lib/libpnd.so.1.0.1 /usr/lib/libpnd.so.1 
}

FILES_${PN} += "${bindir} ${sbindir}"
