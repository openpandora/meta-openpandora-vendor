DESCRIPTION = "Config files for Openbox-based GUI"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

RDEPENDS_${PN} = "libx11-locale"

PR = "r2"

SRCREV = "9e04a9b89504db67e28e76ce6ae56dd5d158741a"

SRC_URI = "git://code.google.com/p/pandora-openbox-gui/;protocol=http"
S = "${WORKDIR}/git"
	
do_install() {
	
	install -d ${D}${prefix}/share/desktop-directories/
	
	install -m 0644 ${S}/desktop-directories/openbox-accessories.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-development.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-documentation.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-education.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-emulator.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-action.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-adventure.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-arcade.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-blocks.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-board.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-cards.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-kids.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-logic.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-other.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-rpg.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-simulation.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-sports.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-games-strategy.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-graphics.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-multimedia.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-network.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-office.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-other.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-settings.directory ${D}${prefix}/share/desktop-directories/
	install -m 0644 ${S}/desktop-directories/openbox-system.directory ${D}${prefix}/share/desktop-directories/
	
	install -d ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/edit-connections.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/file-manager.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/gtk-theme-switch.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/logout.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-accessories.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-development.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-documentation.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-education.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-emulator.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-games.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-games-subdir.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-graphics.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-multimedia.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-network.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-office.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-other.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-settings.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/menu-system.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/pnd-installer.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/restart.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/set-background.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/shutdown.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/suspend.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/switch-gui.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/terminal.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/text-editor.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/tint2.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/toggle-usb.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/web-browser.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/wifi-applet.png ${D}${prefix}/share/icons/openbox/
	install -m 0644 ${S}/icons/wifi-hardware.png ${D}${prefix}/share/icons/openbox/
	
	install -d ${D}${sysconfdir}/skel/
	install -m 0644 ${S}/user/.gtkrc-2.0_openbox ${D}${sysconfdir}/skel/
	install -m 0644 ${S}/user/.gtkrc-2.0_xfwm4 ${D}${sysconfdir}/skel/
	install -m 0644 ${S}/user/.gtkrc.mine ${D}${sysconfdir}/skel/
	
	install -d ${D}${sysconfdir}/skel/Applications/Settings/openbox/
    install -m 0644 ${S}/user/rc.xml ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${S}/user/menu.xml ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${S}/user/environment ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0744 ${S}/user/autostart ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${S}/user/wbar_custom.cfg ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${S}/user/webbrowser ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	install -m 0644 ${S}/user/pndinstaller ${D}${sysconfdir}/skel/Applications/Settings/openbox/
	
	install -d ${D}${sysconfdir}/skel/Applications/Settings/openbox/keybindings/
	install -m 0644 ${S}/user/DEFAULT ${D}${sysconfdir}/skel/Applications/Settings/openbox/keybindings/
	
	install -d ${D}${sysconfdir}/skel/Applications/Settings/tint2/
	install -m 0644 ${S}/user/tint2rc ${D}${sysconfdir}/skel/Applications/Settings/tint2/
	
	install -d ${D}${sysconfdir}/xdg/menus/
	install -m 0644 ${S}/openbox-pnd.menu ${D}${sysconfdir}/xdg/menus/
	
	install -d ${D}${sysconfdir}/xdg/openbox/
	install -m 0644 ${S}/rootmenu.desktop ${D}${sysconfdir}/xdg/openbox/
	
	install -d ${D}${bindir}
	install -m 0755 ${S}/openbox-pandora-session ${D}${bindir}
	install -m 0755 ${S}/openbox-exit ${D}${bindir}
	
	install -d ${D}${prefix}/share/backgrounds/
	install -m 0644 ${S}/openbox_default.jpg ${D}${prefix}/share/backgrounds/
	
}

FILES_${PN} += "${prefix}"




