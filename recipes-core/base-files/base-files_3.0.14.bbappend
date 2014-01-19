FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
# Don't forget to bump PRINC if you update the extra files.
PRINC = "1"

SRC_URI += "file://dot.profile \
            file://dot.bashrc \
            "

do_install_append() {
    install -m 0644 ${WORKDIR}/dot.profile ${D}${sysconfdir}/skel/.profile
    install -m 0644 ${WORKDIR}/dot.bashrc ${D}${sysconfdir}/skel/.bashrc
}
