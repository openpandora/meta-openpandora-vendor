DESCRIPTION = "Config files for Openbox-based GUI"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

PR = "r1"
SRC_URI = " \
	file://COPYING \
	file://desktop-directories/openbox-accessories.directory \
	file://desktop-directories/openbox-development.directory \
	file://desktop-directories/openbox-documentation.directory \
	file://desktop-directories/openbox-education.directory \
	file://desktop-directories/openbox-emulator.directory \
	file://desktop-directories/openbox-games-action.directory \
	file://desktop-directories/openbox-games-adventure.directory \
	file://desktop-directories/openbox-games-arcade.directory \
	file://desktop-directories/openbox-games-blocks.directory \
	file://desktop-directories/openbox-games-board.directory \
	file://desktop-directories/openbox-games-cards.directory \
	file://desktop-directories/openbox-games.directory \
	file://desktop-directories/openbox-games-kids.directory \
	file://desktop-directories/openbox-games-logic.directory \
	file://desktop-directories/openbox-games-other.directory \
	file://desktop-directories/openbox-games-rpg.directory \
	file://desktop-directories/openbox-games-simulation.directory \
	file://desktop-directories/openbox-games-sports.directory \
	file://desktop-directories/openbox-games-strategy.directory \
	file://desktop-directories/openbox-graphics.directory \
	file://desktop-directories/openbox-multimedia.directory \
	file://desktop-directories/openbox-network.directory \
	file://desktop-directories/openbox-office.directory \
	file://desktop-directories/openbox-other.directory \
	file://desktop-directories/openbox-settings.directory \
	file://desktop-directories/openbox-system.directory \
	file://user/autostart \
	file://user/DEFAULT \
	file://user/environment \
	file://user/menu.xml \
	file://user/rc.xml \
	file://user/tint2rc \
	file://user/wbar_custom.cfg \
	file://user/webbrowser \
	file://user/.gtkrc-2.0_openbox \
	file://user/.gtkrc-2.0_xfwm4 \
	file://user/.gtkrc.mine \
	file://openbox-pandora-session \
	file://openbox-exit \
	file://openbox_default.jpg \
	"
	
do_install() {
	
	install -d ${D}${prefix}/share/desktop-directories/
	
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-accessories.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-development.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-documentation.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-education.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-emulator.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-action.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-adventure.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-arcade.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-blocks.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-board.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-cards.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-kids.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-logic.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-other.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-rpg.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-simulation.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-sports.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-games-strategy.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-graphics.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-multimedia.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-network.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-office.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-other.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-settings.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${WORKDIR}/desktop-directories/openbox-system.directory ${D}${prefix}/share/desktop-directories/
	
	
	
	install -d ${D}${sysconfdir}/skel/
	install -m 0644 ${WORKDIR}/user/.gtkrc-2.0_openbox ${D}${sysconfdir}/skel/
	install -m 0644 ${WORKDIR}/user/.gtkrc-2.0_xfwm4 ${D}${sysconfdir}/skel/
	install -m 0644 ${WORKDIR}/user/.gtkrc.mine ${D}${sysconfdir}/skel/
	
	install -d ${D}${sysconfdir}/skel/Applications/Settings/openbox/
    install -m 0644 ${WORKDIR}/user/rc.xml ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${WORKDIR}/user/menu.xml ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${WORKDIR}/user/environment ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0744 ${WORKDIR}/user/autostart ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${WORKDIR}/user/wbar_custom.cfg ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${WORKDIR}/user/webbrowser ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	
	install -d ${D}${sysconfdir}/skel/Applications/Settings/openbox/keybindings/
	install -m 0644 ${WORKDIR}/user/DEFAULT ${D}${sysconfdir}/skel/Applications/Settings/openbox/keybindings/
	
	install -d ${D}${sysconfdir}/skel/Applications/Settings/tint2/
	install -m 0644 ${WORKDIR}/user/tint2rc ${D}${sysconfdir}/skel/Applications/Settings/tint2/
	
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/openbox-pandora-session ${D}${bindir}
	install -m 0755 ${WORKDIR}/openbox-exit ${D}${bindir}
	
	install -d ${D}${prefix}/share/backgrounds/
	install -m 0644 ${WORKDIR}/openbox_default.jpg ${D}${prefix}/share/backgrounds/
	
}

FILES_${PN} += "${prefix}"




