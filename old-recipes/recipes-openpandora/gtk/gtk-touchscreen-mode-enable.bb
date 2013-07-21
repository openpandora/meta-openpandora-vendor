DESCRIPTION = "Enable gtk-touchscreen-mode in gtkrc"

RDEPENDS = "gtk+"

PR = "r1"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"


ALLOW_EMPTY_${PN} = "1"
PACKAGE_ARCH = "all"

pkg_postinst() {
#!/bin/sh
mkdir -p ${sysconfdir}/gtk-2.0
touch ${sysconfdir}/gtk-2.0/gtkrc
sed -i /gtk-touchscreen-mode = 1/d ${sysconfdir}/gtk-2.0/gtkrc
echo 'gtk-touchscreen-mode = 1' >> ${sysconfdir}/gtk-2.0/gtkrc
}

pkg_postrm() {
#!/bin/sh
sed -i /gtk-touchscreen-mode = 1/d ${sysconfdir}/gtk-2.0/gtkrc
}

