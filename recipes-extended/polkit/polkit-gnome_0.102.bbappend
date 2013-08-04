PRINC := "${@int(PRINC) + 1}"
FILESEXTRAPATHS := "${THISDIR}/${PN}"
PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI_append = "file://polkit-gnome-authentication-agent-1.desktop"

do_install_append() {
	install -d ${D}${sysconfdir}/xdg/autostart/
	install -m 0644 ${WORKDIR}/polkit-gnome-authentication-agent-1.desktop ${D}${sysconfdir}/xdg/autostart/
}

