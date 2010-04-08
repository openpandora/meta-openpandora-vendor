DESCRIPTION = "Scripts to support system options on the OpenPandora."
LICENSE = "GPLV2"

COMPATIBLE_MACHINE = "omap3-pandora"

DEPENDS = "zenity dbus"
RDEPENDS = "zenity dbus"

PR = "r9"

SRC_URI = " \
          file://op_bright.sh \
          file://op_cpuspeed.sh \
          file://op_cpuspeed.desktop \          
          file://op_wifi.sh \
          file://op_wifi.desktop \          
          file://op_bluetooth.sh \
          file://op_bluetooth-check.desktop \
          file://op_bluetooth.desktop \          
          file://op_defaultgui.sh \
          file://op_defaultgui.desktop \
          file://op_switchgui.sh \
          file://op_switchgui.desktop \
          file://startnetbooklauncher \
          file://startmmenu \
          file://op_calibrate.sh \
          file://op_calibrate.desktop \
          file://op_datetime.sh \
          file://op_datetime.desktop \
          file://gui.conf \
"

do_install() {
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_bright.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_cpuspeed.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_wifi.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_bluetooth.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_defaultgui.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_switchgui.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_calibrate.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_datetime.sh ${D}${prefix}/pandora/scripts/
          
          install -d ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_cpuspeed.desktop ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_wifi.desktop ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_bluetooth.desktop ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_defaultgui.desktop ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_switchgui.desktop ${D}${datadir}/applications/          
          install -m 0644 ${WORKDIR}/op_calibrate.desktop ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_datetime.desktop ${D}${datadir}/applications/
          


          install -d ${D}${sysconfdir}/xdg/autostart/
          install -m 0644 ${WORKDIR}/op_bluetooth-check.desktop ${D}${sysconfdir}/xdg/autostart/op_bluetooth-check.desktop

	  install -d ${D}${sysconfdir}/pandora/conf/
          install -m 0644 ${WORKDIR}/gui.conf ${D}${sysconfdir}/pandora/conf/gui.conf


          install -d ${D}${bindir}/
          install -m 0755 ${WORKDIR}/startnetbooklauncher ${D}${bindir}/
          install -m 0755 ${WORKDIR}/startmmenu ${D}${bindir}/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
