PRINC := "${@int(PRINC) + 2}"
FILESEXTRAPATHS := "${THISDIR}/${PN}"

DESCRIPTION = "Simple DirectMedia Layer (X11, Framebuffer, +some OMAP support)"
LIC_FILES_CHKSUM = "file://COPYING;md5=27818cd7fd83877a8e3ef82b82798ef4"


SRCREV = "79b5de0442e5ec99b36a6e5dabfc6031232f93ff"

SRC_URI = " \
    git://notaz.gp2x.de/~notaz/sdl_omap.git;protocol=git;branch=master \
    file://configure_tweak.patch \
"
#file://sdl.m4 


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

