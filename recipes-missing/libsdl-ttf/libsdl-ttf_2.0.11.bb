DESCRIPTION = "Simple DirectMedia Layer truetype font library."
SECTION = "libs"
DEPENDS = "virtual/libsdl freetype"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=22800d1b3701377aae0b61ee36f5c303"

PR = "r1"

SRC_URI = "http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-${PV}.tar.gz \
           file://configure.patch \
          "

S = "${WORKDIR}/SDL_ttf-${PV}"
EXTRA_OECONF += "SDL_CONFIG=${STAGING_BINDIR_CROSS}/sdl-config "

inherit autotools

TARGET_CC_ARCH += "${LDFLAGS}"

do_configure_prepend() {
  
   MACROS="libtool.m4 lt~obsolete.m4 ltoptions.m4 ltsugar.m4 ltversion.m4"
 
   for i in ${MACROS}; do
     rm acinclude/$i
   done

}

SRC_URI[md5sum] = "61e29bd9da8d245bc2471d1b2ce591aa"
SRC_URI[sha256sum] = "724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7"
