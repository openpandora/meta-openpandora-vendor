DESCRIPTION = "A lightweight panel and taskbar"
SECTION = "x11/utils"
DEPENDS = "glib-2.0 imlib2"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

PR="r0"

SRCREV = "r652"
          
SRC_URI = "svn://tint2.googlecode.com/svn/;module=trunk;protocol=http \
		file://tint2_update_battery.patch \
		file://tint2_update_launchers.patch \
		file://tint2_update_tintwizard.patch \
		file://tint2_remove_cruft.patch \
"
S = "${WORKDIR}/trunk"

inherit cmake


