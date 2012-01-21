DESCRIPTION = "LightDM Webkit Greeter"
LICENSE = "GPLv3 LGPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

DEPENDS = "lightdm libxklavier consolekit polkit"

PR = "r0"

inherit autotools

SRC_URI = " \
            http://launchpad.net/lightdm-webkit-greeter/trunk/${PV}/+download/lightdm-webkit-greeter-${PV}.tar.gz \
"

SRC_URI[md5sum] = "ff8247d5bbf3026140531061fbf1f51e"
SRC_URI[sha256sum] = "53d6d41127b7c4cccc239d5d98edce868f18f95c76766cd1681ef58d1678c120"

do_install_append() {
	# Basic tweaks to the lightdm-gtk-greeter.conf
	sed -i -e "s|#show-language-selector=false|show-language-selector=true|g" ${D}/${sysconfdir}/lightdm/lightdm-gtk-greeter.conf || true
	sed -i -e "s|#xft-rgba=|xft-rgba=rgb|g" ${D}/${sysconfdir}/lightdm/lightdm-gtk-greeter.conf || true
	sed -i -e "s|#xft-hintstyle=|xft-hintstyle=slight|g" ${D}/${sysconfdir}/lightdm/lightdm-gtk-greeter.conf || true
	# Carry out more tweaks in a .bbappend to customise the setup.
}

FILES_${PN} += "${datadir}/xgreeters/lightdm* \
        ${datadir}/lightdm* \
"

pkg_postinst_${PN} () {
    # Can't do this offline
    # Register as default LightDM greeter.
    sed -i -e "s|#greeter-session=example-gtk-gnome|greeter-theme=lightdm-webkit-greeter|g" ${sysconfdir}/lightdm/lightdm.conf || true    
}

pkg_postrm_${PN} () {
    # Set back to default when removed. Can't think of a nice way to do this right now that's safe?
    sed -i -e "s|greeter-theme=lightdm-webkit-greeter|#greeter-session=example-gtk-gnome|g" ${sysconfdir}/lightdm/lightdm.conf || true    
}
