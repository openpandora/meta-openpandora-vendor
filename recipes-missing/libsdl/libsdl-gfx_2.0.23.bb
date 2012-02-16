DESCRIPTION = "Simple DirectMedia Layer graphic primitives library."
SECTION = "libs"
PRIORITY = "optional"
DEPENDS = "zlib libpng jpeg virtual/libsdl"
LICENSE = "LGPL"
LIC_FILES_CHKSUM = "file://COPYING;md5=6b58fc50681593e1de3d0029b9bb3395"
SRC_URI = "http://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-${PV}.tar.gz"
S = "${WORKDIR}/SDL_gfx-${PV}"

inherit autotools

EXTRA_OECONF = "--disable-mmx"
EXTRA_OECONF += "SDL_CONFIG=${STAGING_BINDIR_CROSS}/sdl-config "
TARGET_CC_ARCH += "${LDFLAGS}"

SRC_URI[md5sum] = "fcc3c4f2d1b4943409bf7e67dd65d03a"
SRC_URI[sha256sum] = "41bd601d65bba19eeac80a62570ce120098414ece22de402a8ee81b10e07faea"
