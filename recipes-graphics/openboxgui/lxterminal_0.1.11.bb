SUMMARY = "Lightweight terminal"
DESCRIPTION = "Desktop-independent VTE-based terminal emulator with support for multiple tabs"
HOMEPAGE = "http://lxde.sourceforge.net/"
BUGTRACKER = ""

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=59530bdf33659b29e73d4adb9f9f6552"

SECTION = "x11/utils"
DEPENDS = "glib-2.0 vte"

SRC_URI = "${SOURCEFORGE_MIRROR}/lxde/lxterminal-${PV}.tar.gz"

SRC_URI[md5sum] = "fd9140b45c0f28d021253c4aeb8c4aea"
SRC_URI[sha256sum] = "f495166b308a96e8c30c8892b33ab163f3865253a9bbd4bdac462f974fda7253"

PR = "r0"

inherit autotools pkgconfig
