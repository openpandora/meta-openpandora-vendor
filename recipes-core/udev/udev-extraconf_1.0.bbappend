FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGE_ARCH_openpandora = "${MACHINE_ARCH}"

SRC_URI_append_openpandora = " \
    file://recipes_udev_udev-151_omap3-pandora_mount.sh \
"

do_install_append() {
    if [ "${MACHINE}" = "openpandora" ]; then
        install -m 0755 ${WORKDIR}/recipes_udev_udev-151_omap3-pandora_mount.sh ${D}${sysconfdir}/udev/scripts/mount.sh
        
    fi
}

PRINC := "${@int(PRINC) + 2}"
