DESCRIPTION = "GKSu is a library that provides a Gtk+ frontend to su and sudo."
LICENSE = "GPLv2"
DEPENDS = "gtk+ libgksu nautilus"

SRC_URI[md5sum] = "cacbcac3fc272dce01c6ea38354489e2"
SRC_URI[sha256sum] = "a1de3dca039d88c195fcdc9516379439a1d699750417f1e655aa2101a955ee5a"

LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

SRC_URI = "http://people.debian.org/~kov/gksu/gksu-${PV}.tar.gz \
	   file://nautilus-gksu-glib.patch \
"

inherit autotools

PACKAGES =+ "${PN}-nautilus-extension"
FILES_${PN}-nautilus-extension = "${libdir}/nautilus/extensions-2.0/*.so"
