DESCRIPTION = "Default 'new user' files on the OpenPandora."

COMPATIBLE_MACHINE = "omap3-pandora"

## /etc/skel is used by Shadow's useradd so you really have that installed for this to make sense ;)
#RDEPENDS = "shadow"

PR = "r3"

SRC_URI = " \
          file://.xinitrc \     
"

do_install() {
          install -d ${D}${sysconfdir}/skel/
          install -m 0777 ${WORKDIR}/.xinitrc ${D}${sysconfdir}/skel/         
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += "${prefix} ${datadir}"
