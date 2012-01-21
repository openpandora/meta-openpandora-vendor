DESCRIPTION = "LightDM Graphical login manager"
LICENSE = "GPLv3 LGPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

# Note: Defaults to building and using the GTK+ greeter screen at the moment.

DEPENDS = "libpam virtual/xserver consolekit libxklavier gtk+"

PR = "r3"

inherit autotools update-rc.d

SRC_URI = " \
            http://launchpad.net/lightdm/trunk/${PV}/+download/lightdm-${PV}.tar.gz \
            file://lightdm \
	    file://lightdm.service \
	    file://lightdm.pam \
	    file://lightdm-autologin.pam \
	    file://Xsession \
"

SRC_URI[md5sum] = "e42e1ac0b07b3591de44ff7b6daa6c7a"
SRC_URI[sha256sum] = "285b7df76cd580ccb11d606fdd4ec8dfc3751891485d81c654d063264c47fc29"

EXTRA_OECONF = " --disable-static \
                 --with-greeter-user=lightdm \
"

do_install_append() {
	install -d ${D}/${sysconfdir}/lightdm
	install -m 0755 ${WORKDIR}/Xsession ${D}/${sysconfdir}/lightdm
	
	install -d ${D}/${sysconfdir}/init.d
	install -m 0755 ${WORKDIR}/lightdm ${D}/${sysconfdir}/init.d/

	# Install PAM service and special service for autologin case.
	install -d ${D}/${sysconfdir}/pam.d
	install -m 0644 ${WORKDIR}/lightdm.pam ${D}/${sysconfdir}/pam.d/lightdm
	install -m 0644 ${WORKDIR}/lightdm-autologin.pam ${D}/${sysconfdir}/pam.d/lightdm-autologin

	install -d ${D}${base_libdir}/systemd/system
	install -m 0644 ${WORKDIR}/lightdm.service ${D}${base_libdir}/systemd/system/ 

	# Add default Xsession wrapper and tweaks
	sed -i -e "s|#greeter-user=lightdm|greeter-user=lightdm|g" ${D}/${sysconfdir}/lightdm/lightdm.conf || true
	sed -i -e "s|#session-wrapper=lightdm-session|session-wrapper=${sysconfdir}/lightdm/Xsession|g" ${D}/${sysconfdir}/lightdm/lightdm.conf || true    
}

PACKAGES =+ "lightdm-systemd"
FILES_lightdm-systemd = "${base_libdir}/systemd"
RDEPENDS_lightdm-systemd = "lightdm"

pkg_postinst_lightdm-systemd() {
	# Can't do this offline
	if [ "x$D" != "x" ]; then
		exit 1
	fi
	
	systemctl enable lightdm.service
}

pkg_postrm_lightdm-systemd() {
	# Can't do this offline
	if [ "x$D" != "x" ]; then
		exit 1
	fi

	systemctl disable lightdm.service
}

FILES_${PN} += "${datadir}/vala* \
"

FILES_${PN}-dbg += "${libexecdir}/lightdm/.debug \
"

CONFFILES_${PN} += "${sysconfdir}/init.d/lightdm"
RRECOMMENDS_${PN} += "openssh-misc desktop-file-utils polkit consolekit"

INITSCRIPT_NAME = "lightdm"
INITSCRIPT_PARAMS = "start 99 5 2 . stop 20 0 1 6 ."

pkg_postinst_${PN} () {
    # Can't do this offline
    if [ "x$D" != "x" ]; then
        exit 1
    fi
    grep "^lightdm:" /etc/group > /dev/null || addgroup lightdm
    grep "^lightdm:" /etc/passwd > /dev/null || adduser --disabled-password --system --home /etc/lightdm lightdm --ingroup lightdm -g lightdm

    # Register up as default dm
    mkdir -p ${sysconfdir}/X11/
    echo "${bindir}/lightdm" > ${sysconfdir}/X11/default-display-manager
}

pkg_postrm_${PN} () {
    deluser lightdm || true
    delgroup lightdm || true
    sed -i /lightdm/d ${sysconfdir}/X11/default-display-manager || true
}
