SUMMARY = "Text Editor"
DESCRIPTION = "A simple text editor for Xfce"
HOMEPAGE = ""
BUGTRACKER = ""

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

SECTION = "x11/utils"
DEPENDS = "gtk+ dbus-glib gtksourceview2"

SRC_URI = "http://archive.xfce.org/src/apps/mousepad/0.3/mousepad-${PV}.tar.bz2"

SRC_URI[md5sum] = "dcfcdfaa8a19c89f35d5f6f64753e6e1"
SRC_URI[sha256sum] = "10f27506994d0d0b8f9e02555404a144babedab97517abe3b6be8b2d21ff046d"

PR = "r0"

inherit autotools pkgconfig
