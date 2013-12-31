DESCRIPTION = "Scripts to support system options on the OpenPandora."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

COMPATIBLE_MACHINE = "openpandora"

RDEPENDS_${PN} = "bash sed gawk zenity dbus xwininfo procps bc python-pygtk gksu pstree xdotool"

PR = "r149"
PRINC := "${@int(PRINC) + 1}"

SRC_URI = " \
          file://LICENSE \
          file://op_paths.sh \
          file://op_bright.sh \
          file://op_cpuspeed.sh \
          file://op_cpuspeed.pnd \     
	  file://op_usbhost.sh \
          file://op_usbhost.pnd \
          file://op_osupgrade.sh \
          file://op_osupgrade.pnd \
          file://op_sysspeed.sh \
	  file://op_createsd.sh \
	  file://op_createsd.pnd \
          file://op_startupmanager.sh \
          file://op_startupmanager.pnd \
          file://op_switchgui.sh \
          file://op_switchgui.pnd \
          file://startmmenu \    
          file://stopmmenu \
          file://op_calibrate.sh \
          file://op_calibrate.pnd \
          file://op_datetime.sh \
          file://op_datetime.pnd \
          file://op_usermanager.sh \
          file://op_usermanager.pnd \
          file://op_lcdsettings.sh \
          file://op_lcdsettings.pnd \
          file://op_ledsettings.sh \
          file://op_ledsettings.pnd \
	  file://op_cpusettings.sh \
          file://op_cpusettings.pnd \
          file://op_lcdrate.sh \
          file://op_videofir.sh \
          file://op_storage.sh \
	  file://op_storage.pnd \
          file://op_nubmode.py \
	  file://op_nubmode.pnd \
	  file://op_nubchange.sh \
	  file://op_lidsettings.pnd \
	  file://op_lidsettings.sh \
	  file://op_touchinit.sh \
          file://op_tvout.sh \
	  file://op_tvout.pnd \
	  file://ConfigModel.py \
	  file://TVoutConfig.py \
	  file://op_inputtest.pnd \
          file://gui.conf \
	  file://cpu.conf \
	  file://led.conf \
          file://gamma.conf \
          file://service.conf \
	  file://nub_profiles.conf \
	  file://tvout-profiles.conf \
	  file://nubmode.glade \
	  file://reset_nubs.sh \
	  file://pndlogo.png \
	  file://tvicon.png \
	  file://tvout.glade \
          file://default_up \
          file://none_up \
          file://op_env.sh \
          file://evince.pnd \
          file://gigolo.pnd \
          file://mousepad.pnd \
          file://ristretto.pnd \
          file://squeeze.pnd \
          file://thunar.pnd \
          file://xchat.pnd \
	  file://gcalctool.pnd \ 
	  file://op_bright_down.sh \ 
	  file://op_lid.sh \  
	  file://op_power.sh \
	  file://op_battlow.sh \ 
	  file://op_bright_up.sh \  
	  file://op_menu.sh \ 
	  file://op_hugetlb.sh \
	  file://op_gamma.sh \
	  file://op_dsp.sh \
	  file://openbox-functions.sh \
"
#          file://compo4all-manager.pnd \
#

do_install() {
          install -d ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_paths.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_osupgrade.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_bright.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_cpuspeed.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_createsd.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_sysspeed.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_cpusettings.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_usbhost.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_startupmanager.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_switchgui.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_calibrate.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_datetime.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_usermanager.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_lcdsettings.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_ledsettings.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_lcdrate.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_videofir.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_nubmode.py ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_nubchange.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_storage.sh ${D}${prefix}/pandora/scripts/
          install -m 0755 ${WORKDIR}/op_tvout.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_bright_down.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_lid.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_power.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_battlow.sh ${D}${prefix}/pandora/scripts/ 
	  install -m 0755 ${WORKDIR}/op_touchinit.sh ${D}${prefix}/pandora/scripts/ 
	  install -m 0755 ${WORKDIR}/op_bright_up.sh ${D}${prefix}/pandora/scripts/  
	  install -m 0755 ${WORKDIR}/op_menu.sh ${D}${prefix}/pandora/scripts/ 
	  install -m 0755 ${WORKDIR}/op_hugetlb.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/op_gamma.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/reset_nubs.sh ${D}${prefix}/pandora/scripts/ 
	  install -m 0644 ${WORKDIR}/pndlogo.png ${D}${prefix}/pandora/scripts/ 
	  install -m 0755 ${WORKDIR}/ConfigModel.py ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/TVoutConfig.py ${D}${prefix}/pandora/scripts/
	  install -m 0644 ${WORKDIR}/tvicon.png ${D}${prefix}/pandora/scripts/ 
	  install -m 0644 ${WORKDIR}/nubmode.glade ${D}${prefix}/pandora/scripts/ 
	  install -m 0644 ${WORKDIR}/tvout.glade ${D}${prefix}/pandora/scripts/ 
	  install -m 0755 ${WORKDIR}/op_lidsettings.sh ${D}${prefix}/pandora/scripts/ 
	  install -m 0755 ${WORKDIR}/op_dsp.sh ${D}${prefix}/pandora/scripts/
	  install -m 0755 ${WORKDIR}/openbox-functions.sh ${D}${prefix}/pandora/scripts/ 


          install -d ${D}${prefix}/pandora/apps/
          install -m 0755 ${WORKDIR}/op_calibrate.pnd ${D}${prefix}/pandora/apps/
          install -m 0755 ${WORKDIR}/op_createsd.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_cpuspeed.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_datetime.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_lcdsettings.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_ledsettings.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_cpusettings.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_nubmode.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_startupmanager.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_storage.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_switchgui.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_usermanager.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_usbhost.pnd ${D}${prefix}/pandora/apps/
          install -m 0755 ${WORKDIR}/op_tvout.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_inputtest.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_lidsettings.pnd ${D}${prefix}/pandora/apps/
	  install -m 0755 ${WORKDIR}/op_osupgrade.pnd ${D}${prefix}/pandora/apps/
#	  install -m 0755 ${WORKDIR}/compo4all-manager.pnd ${D}${prefix}/pandora/apps/

	  install -d ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/evince.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/gigolo.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/mousepad.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/ristretto.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/squeeze.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/thunar.pnd ${D}${prefix}/pandora/mmenu/
          install -m 0755 ${WORKDIR}/xchat.pnd ${D}${prefix}/pandora/mmenu/
	  install -m 0755 ${WORKDIR}/gcalctool.pnd ${D}${prefix}/pandora/mmenu/

          install -d ${D}${sysconfdir}/pandora/conf/
          install -m 0644 ${WORKDIR}/gui.conf ${D}${sysconfdir}/pandora/conf/gui.conf
          install -m 0644 ${WORKDIR}/led.conf ${D}${sysconfdir}/pandora/conf/led.conf
	  install -m 0644 ${WORKDIR}/cpu.conf ${D}${sysconfdir}/pandora/conf/cpu.conf
          install -m 0644 ${WORKDIR}/gamma.conf ${D}${sysconfdir}/pandora/conf/gamma.conf
          install -m 0644 ${WORKDIR}/service.conf ${D}${sysconfdir}/pandora/conf/service.conf
	  install -m 0666 ${WORKDIR}/nub_profiles.conf ${D}${sysconfdir}/pandora/conf/nub_profiles.conf
	  install -m 0666 ${WORKDIR}/tvout-profiles.conf ${D}${sysconfdir}/pandora/conf/tvout-profiles.conf

          install -d ${D}${sysconfdir}/pandora/conf/dss_fir/
          install -m 0644 ${WORKDIR}/default_up ${D}${sysconfdir}/pandora/conf/dss_fir/
          install -m 0644 ${WORKDIR}/none_up ${D}${sysconfdir}/pandora/conf/dss_fir/

          install -d ${D}${sysconfdir}/profile.d/
          install -m 0755 ${WORKDIR}/op_env.sh ${D}${sysconfdir}/profile.d/

          install -d ${D}${bindir}/
          install -m 0755 ${WORKDIR}/startmmenu ${D}${bindir}/
          install -m 0755 ${WORKDIR}/stopmmenu ${D}${bindir}/
}



PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"

CONFFILES_${PN} += " ${sysconfdir}/pandora/conf/gui.conf \
                     ${sysconfdir}/pandora/conf/cpu.conf \
                     ${sysconfdir}/pandora/conf/led.conf \
                     ${sysconfdir}/pandora/conf/gamma.conf \
                     ${sysconfdir}/pandora/conf/service.conf \
                     ${sysconfdir}/pandora/conf/nub_profiles.conf \ 
                     ${sysconfdir}/pandora/conf/tvout-profiles.conf \
"


