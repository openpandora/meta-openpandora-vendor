DESCRIPTION = "Icon theme from the Elementary project"
SECTION = "x11/icons"
HOMEPAGE = "http://www.elementary-project.com/"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://elementary-icon-theme/elementary/COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

inherit gtk-icon-cache

# We have to get the icons from a mirror (LaunchPad) as DeviantArt has a download 
# wrapper to stop simple HTTP gets :(.

SRC_URI = " \
  http://launchpad.net/elementaryicons/2.0/${PV}/+download/elementary-icon-theme-${PV}.tar.gz;name=regular;subdir=${BPN}-${PV} \
"

SRC_URI[regular.md5sum] = "fc4580641089a09cbcf7df38ebddd807"
SRC_URI[regular.sha256sum] = "4cfe73d9da3f6262a724bd787126dcbf0957b107e3f36d22a0baf60fef7706e6"

do_install() {
	install -d ${D}${datadir}/icons/elementary/
	install -d ${D}${datadir}/icons/elementary-mono-dark/	

	cp -R ${S}/elementary-icon-theme/elementary/* ${D}${datadir}/icons/elementary/
	cp -R ${S}/elementary-icon-theme/elementary-mono-dark/* ${D}${datadir}/icons/elementary-mono-dark/
}

FILES_${PN} = "${datadir}/icons/elementary*"
RDEPENDS_${PN} += "gnome-icon-theme"
PACKAGE_ARCH = "all"
