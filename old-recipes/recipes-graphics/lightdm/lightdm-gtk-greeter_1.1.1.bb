DESCRIPTION = "LightDM GTK+ Greeter"
LICENSE = "GPLv3 LGPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

DEPENDS = "lightdm libxklavier gtk+3 consolekit polkit"

PR = "r1"

inherit autotools

SRC_URI = " \
            http://launchpad.net/lightdm-gtk-greeter/trunk/${PV}/+download/lightdm-gtk-greeter-${PV}.tar.gz \        
"

SRC_URI[md5sum] = "6dcbcd2b8e71ab510fd16550368b4996"
SRC_URI[sha256sum] = "bfab54008fbb7ea992c43ca9398a06a65a90c26dc2c64e11b4be7bbabf8b7056"

do_install_append() {
	# Basic tweaks to the lightdm-gtk-greeter.conf
	sed -i -e "s|#show-language-selector=false|show-language-selector=true|g" ${D}/${sysconfdir}/lightdm/lightdm-gtk-greeter.conf || true
	sed -i -e "s|#xft-rgba=|xft-rgba=rgb|g" ${D}/${sysconfdir}/lightdm/lightdm-gtk-greeter.conf || true
	sed -i -e "s|#xft-hintstyle=|xft-hintstyle=slight|g" ${D}/${sysconfdir}/lightdm/lightdm-gtk-greeter.conf || true
	# Carry out more tweaks in a .bbappend to customise the setup.
}

FILES_${PN} += "${datadir}/xgreeters/lightdm* \
"

pkg_postinst_${PN} () {
    # Can't do this offline
    # Register as default LightDM greeter.
    sed -i -e "s|#greeter-session=example-gtk-gnome|greeter-session=lightdm-gtk-greeter|g" ${sysconfdir}/lightdm/lightdm.conf || true    
}

pkg_postrm_${PN} () {
    # Set back to default when removed. Can't think of a nice way to do this right now that's safe?
    sed -i -e "s|greeter-session=lightdm-gtk-greeter|#greeter-session=example-gtk-gnome|g" ${sysconfdir}/lightdm/lightdm.conf || true    
}
