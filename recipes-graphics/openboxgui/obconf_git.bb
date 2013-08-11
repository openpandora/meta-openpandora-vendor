DESCRIPTION = "Openbox Configuration Manager"
LICENSE = "LGPLv2"
DEPENDS = "openbox glib-2.0"
PR = "r1"

SRCREV = "cfde28714e55f76c817d050b0d008123e029aa18"
          
SRC_URI = "git://git.openbox.org/dana/obconf;protocol=git \
		file://obconf_rrtheme.patch \
		file://obconf_smallscreen.patch \
"
S = "${WORKDIR}/git"


LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

inherit autotools pkgconfig gettext

do_configure() {
    ./bootstrap
    oe_runconf
}



