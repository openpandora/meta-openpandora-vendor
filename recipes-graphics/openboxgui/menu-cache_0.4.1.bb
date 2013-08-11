SUMMARY = "Library for caching application menus"
DESCRIPTION = "A library creating and utilizing caches to speed up freedesktop.org application menus"
HOMEPAGE = "http://lxde.sourceforge.net/"
BUGTRACKER = ""

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

SECTION = "x11/libs"
DEPENDS = "glib-2.0 zlib"

SRC_URI = "${SOURCEFORGE_MIRROR}/lxde/menu-cache-${PV}.tar.gz \
		file://menu-cache_codecpack.patch \
"

SRC_URI[md5sum] = "20fed982f5d8e6ec8a56a5b48894ecf0"
SRC_URI[sha256sum] = "4fa9408e353fedba5b7314cbf6b6cd06d873a1424e281aa050d88bb9c0a0191e"

PR = "r2"

inherit autotools pkgconfig
