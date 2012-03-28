DESCRIPTION = "Simple DirectMedia Layer (X11, Framebuffer, +some OMAP support)"
SECTION = "libs"
PRIORITY = "optional"
LICENSE = "LGPL"
LIC_FILES_CHKSUM = "file://COPYING;md5=27818cd7fd83877a8e3ef82b82798ef4"
DEPENDS = "alsa-lib virtual/libgl virtual/libx11 libxext tslib"
PROVIDES = "virtual/libsdl"
PR = "r4"

SRCREV = "b260fb56d8eb049e5dce95a92b5c1189ea29f8b4"

SRC_URI = " \
  git://notaz.gp2x.de/~notaz/sdl_omap.git;protocol=git;branch=master \
  file://sdl.m4 \
"

S = "${WORKDIR}/git"

inherit autotools binconfig pkgconfig

EXTRA_OECONF = " \
  --disable-static --disable-debug --enable-cdrom --enable-threads --enable-timers --enable-endian \
  --enable-file --enable-oss --enable-alsa --disable-esd --disable-arts \
  --disable-diskaudio --disable-nas --disable-esd-shared --disable-esdtest \
  --disable-mintaudio --disable-nasm --enable-video-x11 --disable-video-dga \
  --enable-video-fbcon --disable-video-directfb --disable-video-ps2gs \
  --disable-video-xbios --disable-video-gem --disable-video-dummy \
  --enable-video-opengl --enable-input-events --enable-pthreads \
  --disable-video-picogui --disable-video-qtopia --enable-dlopen \
  --enable-input-tslib --disable-video-ps3 \
"

do_configure_prepend() {
  sh autogen.sh
}

do_configure() { 
  oe_runconf
}

do_configure_append () {
  cd ${S}

  # prevent libtool from linking libs against libstdc++, libgcc, ...
  cat ${TARGET_PREFIX}libtool | sed -e 's/postdeps=".*"/postdeps=""/' > ${TARGET_PREFIX}libtool.tmp
  mv ${TARGET_PREFIX}libtool.tmp ${TARGET_PREFIX}libtool

  # copy new sdl.m4 macrofile to the dir for installing
  cp ${WORKDIR}/sdl.m4 ${S}/
}

#do_stage() {
#  autotools_stage_all		
#  rm ${STAGING_LIBDIR}/libSDL.la
#}

FILES_${PN} = "${libdir}/lib*.so.*"
FILES_${PN}-dev += "${bindir}/*config"

