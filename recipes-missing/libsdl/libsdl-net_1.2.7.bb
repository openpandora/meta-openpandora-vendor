DESCRIPTION = "Simple DirectMedia Layer networking library."
SECTION = "libs/network"
PRIORITY = "optional"
DEPENDS = "virtual/libsdl"
LICENSE = "LGPL"
LIC_FILES_CHKSUM = "file://COPYING;md5=27818cd7fd83877a8e3ef82b82798ef4"
PR = "r1"

SRC_URI = "http://www.libsdl.org/projects/SDL_net/release/SDL_net-${PV}.tar.gz \
	   file://libtool2.patch \
	  "

S = "${WORKDIR}/SDL_net-${PV}"

inherit autotools

EXTRA_OECONF += "SDL_CONFIG=${STAGING_BINDIR_CROSS}/sdl-config"

SRC_URI[md5sum] = "6bd4662d1423810f3140d4da21b6d912"
SRC_URI[sha256sum] = "2ce7c84e62ff8117b9f205758bcce68ea603e08bc9d6936ded343735b8b77c53"
