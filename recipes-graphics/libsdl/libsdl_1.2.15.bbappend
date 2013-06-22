PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS := "${THISDIR}/${PN}"

DESCRIPTION = "Simple DirectMedia Layer (X11, Framebuffer, +some OMAP support)"
LIC_FILES_CHKSUM = "file://COPYING;md5=27818cd7fd83877a8e3ef82b82798ef4"


SRCREV = "ee7e6b2d8bc82029aac405d13f719f4532851224"

SRC_URI = " \
    git://notaz.gp2x.de/~notaz/sdl_omap.git;protocol=git;branch=master \
    file://sdl.m4 \
"

S = "${WORKDIR}/git" 
  
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
PACKAGE_ARCH_openpandora = "${MACHINE_ARCH}"

