DESCRIPTION = "Default 'new user' files on the OpenPandora."

COMPATIBLE_MACHINE = "omap3-pandora"

# /etc/skel is used by Shadow's useradd so you really have that installed for this to make sense ;)
RDEPENDS = "shadow"

PR = "r2"

SRC_URI = " \
  file://.xinitrc \     
  file://bashrc \
  file://profile \
  file://mplayconfig \
"

do_install() {
  install -d ${D}${sysconfdir}/skel/
  install -m 0644 ${WORKDIR}/.xinitrc ${D}${sysconfdir}/skel/
  install -m 0644 ${WORKDIR}/bashrc ${D}${sysconfdir}/skel/.bashrc
  install -m 0644 ${WORKDIR}/profile ${D}${sysconfdir}/skel/.profile

  install -d ${D}${sysconfdir}/skel/.mplayer/
  install -m 0644 ${WORKDIR}/mplayconfig ${D}${sysconfdir}/skel/.mplayer/config
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
