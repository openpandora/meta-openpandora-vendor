DESCRIPTION = "A tray applet to change various Pandora-related settings"
LICENSE = "Zlib"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ca68c715b970233cac6617f93bab0593"
PR = "r8"

PARALLEL_MAKE = ""
DEPENDS = "gtk+"

inherit pkgconfig

SRC_URI = " \
          git://github.com/slaeshjag/pandora-configbutton.git;protocol=git;branch=master \
	  file://cpu.png \
          file://tvout.png \   
          file://usb.png \
	  file://wifi.png \
	  file://bt.png \
	  file://Pandora-Configtray.desktop \
"

SRCREV = "85cc7fb5eed20a77a660f89ca88e5a398c8f00b0"

S = "${WORKDIR}/git"

# disable environment-overrides
EXTRA_OEMAKE = "MAKEFLAGS="

do_install() {
	install -d ${D}${bindir}/
	install -m 0755 ${S}/configbutton ${D}${bindir}/
	install -d ${D}${datadir}/configbutton/
	install -m 0644 ${S}/plugin/bin/bluetooth.so ${D}${datadir}/configbutton/
	install -m 0644 ${S}/plugin/bin/cpuspeed.so ${D}${datadir}/configbutton/
	install -m 0644 ${S}/plugin/bin/tvout.so ${D}${datadir}/configbutton/
	install -m 0644 ${S}/plugin/bin/usbhost.so ${D}${datadir}/configbutton/
	install -m 0644 ${S}/plugin/bin/wifi.so ${D}${datadir}/configbutton/
	install -d ${D}${prefix}/share/icons/pandora/
        install -m 0644 ${WORKDIR}/cpu.png ${D}${prefix}/share/icons/pandora/
	install -m 0644 ${WORKDIR}/wifi.png ${D}${prefix}/share/icons/pandora/
	install -m 0644 ${WORKDIR}/tvout.png ${D}${prefix}/share/icons/pandora/
	install -m 0644 ${WORKDIR}/bt.png ${D}${prefix}/share/icons/pandora/
	install -m 0644 ${WORKDIR}/usb.png ${D}${prefix}/share/icons/pandora/
	install -d ${D}${sysconfdir}/skel/Applications/Settings/autostart/
	install -m 0644 ${WORKDIR}/Pandora-Configtray.desktop ${D}${sysconfdir}/skel/Applications/Settings/autostart/Pandora-Configtray.desktop
}

FILES_${PN} += "${prefix} ${datadir}"
