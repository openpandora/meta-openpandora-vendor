DESCRIPTION = "Monospaced font designed for long (8+ hours per day) work with computers."
LICENSE = "OFL"

PR = "r1"

inherit autotools

SECTION = "fonts"

DEPENDS = "perl"

LIC_FILES_CHKSUM = "file://OFL.TXT;md5=9cadb26f4c5c005618c5ae74f041ec54"

SRC_URI = "http://sourceforge.net/projects/terminus-font/files/terminus-font-${PV}/terminus-font-${PV}.tar.gz"

SRC_URI[md5sum] = "a8e792fe6e84c86ed2b6ed3e2a12ba66"
SRC_URI[sha256sum] = "f6f4876a4dabe6a37c270c20bb9e141e38fb50e0bba200e1b9d0470e5eed97b7"

FILES_${PN} += "/usr/share/fonts/terminus/*"

do_configure_prepend () {
        chmod +x configure
}

pkg_postinst_append_${PN}() {
    if [ -z "$D" ]; then
        update-fonts
    fi
}

pkg_postrm_append_${PN}() {
    if [ -z "$D" ]; then
        update-fonts
    fi
}

inherit allarch

