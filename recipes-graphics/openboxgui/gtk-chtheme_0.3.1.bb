DESCRIPTION = "A program to change your gtk theme"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"
SECTION = "x11/utils"
DEPENDS = "glib-2.0 gtk+"

PR = "r1"

SRC_URI = "http://plasmasturm.org/code/gtk-chtheme/gtk-chtheme-${PV}.tar.bz2 \
		file://gtk-chtheme_gtkapi.patch \
"

SRC_URI[md5sum] = "f688053bf26dd6c4f1cd0bf2ee33de2a"
SRC_URI[sha256sum] = "26f4b6dd60c220d20d612ca840b6beb18b59d139078be72c7b1efefc447df844"

inherit pkgconfig

do_compile()  {
	${CC} $(pkg-config --cflags gtk+-2.0) -DGTK_DISABLE_BROKEN -DGTK_DISABLE_DEPRECATED -DPROJNAME='"Gtk+ 2.0 Change Theme"' -DVERSION='"${PV}"' -c -o util.o util.c
	${CC} $(pkg-config --cflags gtk+-2.0) -DGTK_DISABLE_BROKEN -DGTK_DISABLE_DEPRECATED -DPROJNAME='"Gtk+ 2.0 Change Theme"' -DVERSION='"${PV}"' -c -o stock.o stock.c
	${CC} $(pkg-config --cflags gtk+-2.0) -DGTK_DISABLE_BROKEN -DGTK_DISABLE_DEPRECATED -DPROJNAME='"Gtk+ 2.0 Change Theme"' -DVERSION='"${PV}"' -c -o theme_sel.o theme_sel.c
	${CC} $(pkg-config --cflags gtk+-2.0) -DGTK_DISABLE_BROKEN -DGTK_DISABLE_DEPRECATED -DPROJNAME='"Gtk+ 2.0 Change Theme"' -DVERSION='"${PV}"' -c -o font_sel.o font_sel.c
	${CC} $(pkg-config --cflags gtk+-2.0) -DGTK_DISABLE_BROKEN -DGTK_DISABLE_DEPRECATED -DPROJNAME='"Gtk+ 2.0 Change Theme"' -DVERSION='"${PV}"' -c -o preview_pane.o preview_pane.c
	${CC} $(pkg-config --cflags gtk+-2.0) -DGTK_DISABLE_BROKEN -DGTK_DISABLE_DEPRECATED -DPROJNAME='"Gtk+ 2.0 Change Theme"' -DVERSION='"${PV}"' -c -o about_dialog.o about_dialog.c
	${CC} $(pkg-config --cflags gtk+-2.0) -DGTK_DISABLE_BROKEN -DGTK_DISABLE_DEPRECATED -DPROJNAME='"Gtk+ 2.0 Change Theme"' -DVERSION='"${PV}"' -c -o mainwin.o mainwin.c
	${CC} $(pkg-config --cflags gtk+-2.0) -DGTK_DISABLE_BROKEN -DGTK_DISABLE_DEPRECATED -DPROJNAME='"Gtk+ 2.0 Change Theme"' -DVERSION='"${PV}"' -c -o main.o main.c
	${CC} $(pkg-config --libs gtk+-2.0) util.o stock.o theme_sel.o font_sel.o preview_pane.o about_dialog.o mainwin.o main.o -o gtk-chtheme
}

do_install()  {
	install -d ${D}/usr/bin
	install -c gtk-chtheme ${D}/usr/bin
}


