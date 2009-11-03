DESCRIPTION = "Enable gtk-touchscreen-mode in gtkrc"

RDEPENDS = "gtk+"

PR = "r2"

ALLOW_EMPTY_${PN} = "1"
PACKAGE_ARCH = "all"

pkg_postinst() {
#!/bin/sh
mkdir -p $D${sysconfdir}/gtk-2.0
touch $D${sysconfdir}/gtk-2.0/gtkrc
sed -i /gtk-touchscreen-mode = 1/d $D${sysconfdir}/gtk-2.0/gtkrc
echo 'gtk-touchscreen-mode = 1' >> $D${sysconfdir}/gtk-2.0/gtkrc
}
