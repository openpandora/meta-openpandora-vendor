FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
# Don't forget to bump PRINC if you update the extra files.
PRINC = "1"

SRC_URI += "file://profile \
            file://bashrc \
            "

do_install_append() {
    install -m 0644 ${WORKDIR}/profile ${D}${sysconfdir}/skel/.profile
    install -m 0644 ${WORKDIR}/bashrc ${D}${sysconfdir}/skel/.bashrc
}
