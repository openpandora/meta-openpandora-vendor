DESCRIPTION = "Creates menu entries from menu-cache data for openbox Window Manager"
SECTION = "x11/wm"
DEPENDS = "openbox glib-2.0 gtk+ menu-cache"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

PR="r2"

#SRC_URI = "file://git_openbox_menu/"
#S = "${WORKDIR}/git_openbox_menu"

SRCREV = "26670717bed31b70dd1e386bd9e9163cabb59b5f"
          
SRC_URI = "git://code.google.com/p/pandora-openbox-menu/;protocol=https"
S = "${WORKDIR}/git"

inherit pkgconfig

do_compile() {
	#oe_runmake
	${CC} $(pkg-config --cflags glib-2.0 gtk+-2.0 libmenu-cache) -c menu.c -o menu.o
	${CC} $(pkg-config --libs glib-2.0 gtk+-2.0 libmenu-cache) -o openbox-menu menu.o
}

do_install() {
	oe_runmake install DESTDIR=${D}/usr
}




