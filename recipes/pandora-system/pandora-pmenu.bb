DESCRIPTION = "OpenPandora PMenu launcher"
LICENSE = "GPL"

DEPENDS = "virtual/libsdl libgles-omap3 libgles2d pandora-libpnd libconfig"

PR = "r3"

PARALLEL_MAKE = ""

SRC_URI = " \
  git://github.com/Cpasjuste/pmenu.git;protocol=git;branch=master \
  file://remove-libconfig-from-makefile.patch;patch=1 \
"

SRCREV = "19e7c3c39e33d30f42f26858028389f9159f69e2"

S = "${WORKDIR}/git"

export PNDSDK="${STAGING_DIR}"

TARGET_CC_ARCH += "${LDFLAGS}"
TARGET_CFLAGS += "-Wall -I./include"

do_compile_prepend() {
          cd ${S}/
}

do_compile() {
          oe_runmake 
          oe_runmake deploy
}

do_install() {
          install -d ${D}${sysconfdir}/pandora/pmenu/
          install -m 0644 ${S}/deployment/etc/pandora/pmenu/pmenu.cfg ${D}${sysconfdir}/pandora/pmenu/pmenu.cfg
          
          install -d ${D}${sysconfdir}/pandora/pmenu/skins/NewSkin
	  install -m 0644 ${S}/deployment/etc/pandora/pmenu/skins/NewSkin/* ${D}${sysconfdir}/pandora/pmenu/skins/NewSkin

          install -d ${D}${bindir}/
          install -m 0755 ${S}/deployment/etc/pandora/pmenu/pmenu ${D}${bindir}/pmenu
}

FILES_${PN} += "${bindir} ${sysconfdir}"
