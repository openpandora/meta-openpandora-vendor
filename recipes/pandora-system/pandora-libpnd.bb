DESCRIPTION = "Support for the PND format in Pandora images (lib, daemon, init script etc.)"
LICENSE = "lGPL"

PR = "r15"

PARALLEL_MAKE = ""

SRC_URI = " \
          git://openpandora.org/pandora-libraries.git;protocol=git;branch=master \
          file://rc.pndnotifyd \
          file://rc.pndevmapperd \   
          file://op_pnd_run.desktop \
"

SRCREV = "c92806d9595975c5111630f52eaa7ce2b83880a9"

S = "${WORKDIR}/git"

inherit update-rc.d

TARGET_CC_ARCH += "${LDFLAGS}"
TARGET_CFLAGS += "-Wall -I./include"

INITSCRIPT_NAME = "pndnotifyd-init"
INITSCRIPT_PARAMS = "start 30 5 3 . stop 40 0 1 6 ."

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
          install ${S}/deployment/etc/pandora/conf/eventmap ${D}${sysconfdir}/pandora/conf/eventmap
          install -d ${D}${libdir}/
          cp -pP ${S}/deployment/usr/lib/libpnd* ${D}${libdir}/
          cp -pP ${S}/deployment/usr/lib/libpnd.so.1.0.1 ${D}${libdir}/libpnd.so.1

          install -d ${D}${bindir}/
          install -m 0755 ${S}/deployment/usr/bin/pndnotifyd ${D}${bindir}/pndnotifyd
          install -m 0755 ${S}/deployment/usr/bin/pndevmapperd ${D}${bindir}/pndevmapperd 
          install -m 0755 ${S}/deployment/usr/bin/pndevmapperd ${D}${bindir}/pnd_run 
                   
          install -d ${D}${prefix}/pandora/
          install -d ${D}${prefix}/pandora/apps/
          install -d ${D}${prefix}/pandora/scripts/
          cp -pP ${S}/deployment/usr/pandora/scripts/* ${D}${prefix}/pandora/scripts
          
          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.pndnotifyd ${D}${sysconfdir}/init.d/pndnotifyd-init
          install -m 0755 ${WORKDIR}/rc.pndevmapperd ${D}${sysconfdir}/init.d/pndevmapperd-init          
          
          install -d ${D}${prefix}/local/share/applications/
          
          install -d ${D}${includedir}/
          install -m 0644 ${S}/include/pnd* ${D}${includedir}/
          
          install -d ${D}${sysconfdir}/sudoers.d/
          install -m 440 ${S}/testdata/sh/sudoers ${D}${sysconfdir}/sudoers.d/01_libpnd
          
          install -d ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_pnd_run.desktop ${D}${datadir}/applications/          
}

FILES_${PN} += "${bindir} ${sbindir} ${prefix}/pandora/*"
FILES_${PN}-dev += "${libdir}/libpnd.a ${includedir}/pnd*"
