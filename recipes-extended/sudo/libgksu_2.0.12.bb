DESCRIPTION = "Gksu authorization library"
LICENSE = "LGPLv2"
DEPENDS = "gtk+ gconf startup-notification gnome-keyring libgtop"
RRECOMMENDS_${PN} = "gksu"
PR = "r6"

SRC_URI[md5sum] = "c7154c8806f791c10e7626ff123049d3"
SRC_URI[sha256sum] = "22f9cfc3627dcb6774b9aff66c6ea6554f3b34b82bbfa2467b821e67874c3faf"

LIC_FILES_CHKSUM = "file://COPYING;md5=c46bda00ffbb0ba1dac22f8d087f54d9"

SRC_URI = "http://people.debian.org/~kov/gksu/libgksu-${PV}.tar.gz \
		file://libgksu_spaces_to_tabs.patch \
		file://libgksu_makefile_am_update.patch \
		file://01_revert_forkpty.patch \
"

inherit autotools lib_package


EXTRA_OECONF += " \
  --disable-gtk-doc \ 
"

FILES_${PN}-bin += "${datadir}/applications/gksu-properties.desktop \
                      ${datadir}/pixmaps/gksu.png \
"
