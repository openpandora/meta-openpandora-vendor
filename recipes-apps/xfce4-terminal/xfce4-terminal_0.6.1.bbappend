
PRINC := "${@int(PRINC) + 1}"

do_install_append() {
    ln -s xfce4-terminal ${D}${bindir}/terminal
}

PACKAGE_ARCH_openpandora = "${MACHINE_ARCH}"
