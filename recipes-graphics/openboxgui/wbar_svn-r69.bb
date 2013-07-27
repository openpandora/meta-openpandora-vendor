DESCRIPTION = "A simple and highly customizable quick-launch tool"
SECTION = "x11/utils"
DEPENDS = "openbox imlib2 libglade"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

PR="r0"

SRCREV = "r69"
          
SRC_URI = "svn://wbar.googlecode.com/svn/;module=trunk;protocol=http \
		file://wbar_remove_cruft.patch \
"
S = "${WORKDIR}/trunk"

inherit autotools

EXTRA_OECONF += " \
  --disable-nls \
  --disable-wbar-config \
"
