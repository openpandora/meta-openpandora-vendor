DESCRIPTION = "Support for the PND format in Pandora images (lib, daemon, init script etc.)"
LICENSE = "lGPL"
LIC_FILES_CHKSUM = "file://LGPL.txt;md5=fbc093901857fcd118f065f900982c24"

PR = "r48"

PARALLEL_MAKE = ""

DEPENDS = "virtual/libsdl libsdl-image libsdl-gfx libsdl-ttf"

SRC_URI = " \
          git://openpandora.org/pandora-libraries.git;protocol=git;branch=master \
          file://rc.pndnotifyd \
          file://rc.pndevmapperd \   
          file://op_pnd_run.desktop \
"

SRCREV = "6b70206ed7cdf2c7fd7e629c87af2520dc87c093"

S = "${WORKDIR}/git"

inherit update-rc.d

TARGET_CC_ARCH += "${LDFLAGS}"
TARGET_CFLAGS += "-Wall -I./include -I${STAGING_INCDIR}/usr/include -I${STAGING_INCDIR}/SDL "

PACKAGES =+ "${PN}-pndnotifyd ${PN}-pndevmapperd ${PN}-minimenu"

RDEPENDS_${PN} += "${PN}-pndnotifyd ${PN}-pndevmapperd ${PN}-minimenu"

INITSCRIPT_PACKAGES = "${PN}-pndnotifyd ${PN}-pndevmapperd"

INITSCRIPT_NAME_${PN}-pndnotifyd = "pndnotifyd-init"
INITSCRIPT_PARAMS_${PN}-pndnotifyd = "start 30 5 3 . stop 40 0 1 6 ."

INITSCRIPT_NAME_${PN}-pndevmapperd = "pndevmapperd-init"
INITSCRIPT_PARAMS_${PN}-pndevmapperd = "start 30 5 3 . stop 40 0 1 6 ."

RDEPENDS_${PN}-pndnotifyd += "${PN}"
RDEPENDS_${PN}-pndevmapperd += "${PN}"

do_compile_prepend() {
          cd ${S}/
}

do_compile() {
          oe_runmake 
          oe_runmake deploy
}

do_install() {
          install -d ${D}${sysconfdir}/pandora/conf/
          install -m 0644 ${S}/deployment/etc/pandora/conf/apps ${D}${sysconfdir}/pandora/conf/apps
          install -m 0644 ${S}/deployment/etc/pandora/conf/desktop ${D}${sysconfdir}/pandora/conf/desktop
          install -m 0644 ${S}/deployment/etc/pandora/conf/categories ${D}${sysconfdir}/pandora/conf/categories
          install -m 0644 ${S}/deployment/etc/pandora/conf/eventmap ${D}${sysconfdir}/pandora/conf/eventmap
          install -m 0644 ${S}/deployment/etc/pandora/conf/mmenu.conf ${D}${sysconfdir}/pandora/conf/mmenu.conf

          install -d ${D}${libdir}/
          install -m 0644 ${S}/deployment/usr/lib/libpnd* ${D}${libdir}/
          install -m 0644 ${S}/deployment/usr/lib/libpnd.so.1.0.1 ${D}${libdir}/libpnd.so.1

          install -d ${D}${bindir}/
          install -m 0755 ${S}/deployment/usr/bin/pndnotifyd ${D}${bindir}/pndnotifyd
          install -m 0755 ${S}/deployment/usr/bin/pndevmapperd ${D}${bindir}/pndevmapperd 
          install -m 0755 ${S}/deployment/usr/bin/pnd_run ${D}${bindir}/pnd_run 
          install -m 0755 ${S}/deployment/usr/bin/pnd_info ${D}${bindir}/pnd_info
          install -m 0755 ${S}/deployment/usr/bin/mmenu ${D}${bindir}/mmenu
          install -m 0755 ${S}/deployment/usr/bin/mmwrapper ${D}${bindir}/mmwrapper

          install -d ${D}${prefix}/pandora/
          install -d ${D}${prefix}/pandora/apps/
	  install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${S}/deployment/usr/pandora/scripts/* ${D}${prefix}/pandora/scripts
          install -m 0755 ${S}/testdata/scripts/* ${D}${prefix}/pandora/scripts

          install -d ${D}${sysconfdir}/pandora/mmenu/
          install -d ${D}${sysconfdir}/pandora/mmenu/skins/
          install -d ${D}${sysconfdir}/pandora/mmenu/skins/default/
          install -m 0755 ${S}/deployment/etc/pandora/mmenu/skins/default/* ${D}${sysconfdir}/pandora/mmenu/skins/default

          install -d ${D}${sysconfdir}/init.d/
          install -m 0755 ${WORKDIR}/rc.pndnotifyd ${D}${sysconfdir}/init.d/pndnotifyd-init
          install -m 0755 ${WORKDIR}/rc.pndevmapperd ${D}${sysconfdir}/init.d/pndevmapperd-init

          install -d ${D}${prefix}/local/share/applications/

          install -d ${D}${includedir}/
          install -m 0644 ${S}/include/pnd* ${D}${includedir}/

          install -d ${D}${sysconfdir}/sudoers.d/
          install -m 440 ${S}/testdata/sh/sudoers ${D}${sysconfdir}/sudoers.d/99_libpnd

          install -d ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_pnd_run.desktop ${D}${datadir}/applications/
}

FILES_${PN}-minimenu = "${bindir}/mmenu ${bindir}/mmwrapper ${sysconfdir}/pandora/conf/mmenu.conf ${sysconfdir}/pandora/mmenu* "
FILES_${PN}-pndnotifyd = "${sysconfdir}/init.d/pndnotifyd-init ${bindir}/pndnotifyd"
FILES_${PN}-pndevmapperd = "${sysconfdir}/init.d/pndevmapperd-init ${bindir}/pndevmapperd "
FILES_${PN}-dev += "${libdir}/libpnd.a ${includedir}/pnd* "
FILES_${PN}-doc += "${libdir}/libpnd.txt "

# Mop up remaining files.
FILES_${PN} += "${bindir} ${sbindir} ${prefix}/pandora/*"
