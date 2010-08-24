DESCRIPTION = "Scripts to support system options on the OpenPandora."
LICENSE = "GPLV2"

COMPATIBLE_MACHINE = "omap3-pandora"

DEPENDS = "zenity dbus"
RDEPENDS = "zenity dbus"

PR = "r41"

SRC_URI = " \
          file://op_bright.sh \
#	   file://op_bright.desktop \
          file://op_cpuspeed.sh \
          file://op_cpuspeed.pnd \          
          file://op_wifi.sh \
          file://op_wifi.pnd \  
#	  file://op_wifi.desktop \ 
          file://op_bluetooth.sh \
          file://op_bluetooth-check.desktop \
          file://op_bluetooth.desktop \          
          file://op_startupmanager.sh \
          file://op_startupmanager.pnd \
          file://op_switchgui.sh \
          file://op_switchgui.pnd \
          file://startnetbooklauncher \
          file://startmmenu \    
          file://startpmenu \ 
          file://stopmmenu \
          file://op_calibrate.sh \
          file://op_calibrate.pnd \
          file://op_datetime.sh \
          file://op_datetime.pnd \
          file://op_usermanager.sh \
          file://op_usermanager.pnd \
          file://op_lcdsettings.sh \
          file://op_lcdsettings.pnd \
          file://op_lcdrate.sh \
          file://op_videofir.sh \
          file://op_storage.sh \
	  file://op_storage.pnd \
          file://op_nubmode.sh \
	  file://op_nubmode.pnd \
          file://gui.conf \
          file://gamma.conf \
          file://service.conf \
          file://default_up_h \
          file://default_up_v3 \
          file://default_up_v5 \
          file://none_up_h \
          file://none_up_v3 \
          file://none_up_v5 \
          file://op_env.sh \
#          file://pandorascripts.pnd \
	  file://abiword.pnd \
          file://arora.pnd \
          file://claws-mail.pnd \
          file://evince.pnd \
          file://gigolo.pnd \
          file://gnumeric.pnd \
          file://midori.pnd \
          file://mousepad.pnd \
          file://pidgin.pnd \
          file://ristretto.pnd \
          file://squeeze.pnd \
          file://thunar.pnd \
          file://xchat.pnd \
"

do_install() {
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_bright.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_cpuspeed.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_wifi.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_bluetooth.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_startupmanager.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_switchgui.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_calibrate.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_datetime.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_usermanager.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_lcdsettings.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_lcdrate.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_videofir.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_nubmode.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_storage.sh ${D}${prefix}/pandora/scripts/

          install -d ${D}${prefix}/pandora/apps/
          install -m 0755 ${WORKDIR}/op_calibrate.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_cpuspeed.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_datetime.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_lcdsettings.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_nubmode.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_startupmanager.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_storage.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_switchgui.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_usermanager.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_wifi.pnd ${D}${prefix}/pandora/apps/

	  install -d ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/abiword.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/arora.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/claws-mail.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/evince.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/gigolo.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/gnumeric.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/midori.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/mousepad.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/pidgin.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/ristretto.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/squeeze.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/thunar.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/xchat.pnd ${D}${prefix}/pandora/mmenu/

          install -d ${D}${datadir}/applications/
#	  install -m 0644 ${WORKDIR}/op_bright.desktop ${D}${datadir}/applications/
#          install -m 0644 ${WORKDIR}/op_cpuspeed.desktop ${D}${datadir}/applications/
#          install -m 0644 ${WORKDIR}/op_wifi.desktop ${D}${datadir}/applications/
          install -m 0644 ${WORKDIR}/op_bluetooth.desktop ${D}${datadir}/applications/
#          install -m 0644 ${WORKDIR}/op_startupmanager.desktop ${D}${datadir}/applications/
#          install -m 0644 ${WORKDIR}/op_switchgui.desktop ${D}${datadir}/applications/          
#          install -m 0644 ${WORKDIR}/op_calibrate.desktop ${D}${datadir}/applications/
#          install -m 0644 ${WORKDIR}/op_datetime.desktop ${D}${datadir}/applications/
#          install -m 0644 ${WORKDIR}/op_usermanager.desktop ${D}${datadir}/applications/
#          install -m 0644 ${WORKDIR}/op_lcdsettings.desktop ${D}${datadir}/applications/
#	  install -m 0644 ${WORKDIR}/op_nubmode.desktop ${D}${datadir}/applications/
          
          install -d ${D}${sysconfdir}/xdg/autostart/
          install -m 0644 ${WORKDIR}/op_bluetooth-check.desktop ${D}${sysconfdir}/xdg/autostart/op_bluetooth-check.desktop

          install -d ${D}${sysconfdir}/pandora/conf/
          install -m 0644 ${WORKDIR}/gui.conf ${D}${sysconfdir}/pandora/conf/gui.conf
          install -m 0644 ${WORKDIR}/gamma.conf ${D}${sysconfdir}/pandora/conf/gamma.conf
          install -m 0644 ${WORKDIR}/service.conf ${D}${sysconfdir}/pandora/conf/service.conf

          install -d ${D}${sysconfdir}/pandora/conf/dss_fir/
          install -m 0644 ${WORKDIR}/default_up_h ${D}${sysconfdir}/pandora/conf/dss_fir/
          install -m 0644 ${WORKDIR}/default_up_v3 ${D}${sysconfdir}/pandora/conf/dss_fir/
          install -m 0644 ${WORKDIR}/default_up_v5 ${D}${sysconfdir}/pandora/conf/dss_fir/
          install -m 0644 ${WORKDIR}/none_up_h ${D}${sysconfdir}/pandora/conf/dss_fir/
          install -m 0644 ${WORKDIR}/none_up_v3 ${D}${sysconfdir}/pandora/conf/dss_fir/
          install -m 0644 ${WORKDIR}/none_up_v5 ${D}${sysconfdir}/pandora/conf/dss_fir/

          install -d ${D}${sysconfdir}/profile.d/
          install -m 0755 ${WORKDIR}/op_env.sh ${D}${sysconfdir}/profile.d/

          install -d ${D}${bindir}/
          install -m 0755 ${WORKDIR}/startnetbooklauncher ${D}${bindir}/
          install -m 0755 ${WORKDIR}/startmmenu ${D}${bindir}/
          install -m 0755 ${WORKDIR}/startpmenu ${D}${bindir}/
          install -m 0755 ${WORKDIR}/stopmmenu ${D}${bindir}/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
