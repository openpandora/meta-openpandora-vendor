HOMEPAGE = "https://github.com/bzar/panorama"
DESCRIPTION  = "application launcher written in Qt for the OpenPandora portable gaming platform."

LICENSE  = "CC_BY-SA_3.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f582cca373ecede34c7ddbb0e13b388e"

do_sync_submodules() {
	git submodule update --init
}

addtask sync_submodules before do_patch after do_unpack

DEPENDS  = "libpndman openpandora-libpnd "

PR = "r5"

SRCREV = "a7eeb0aab15ee5ef17e9c591260794d9a165ad3a"

inherit qt4x11 cmake

SRC_URI = "git://github.com/bzar/panorama.git;protocol=git \
          "
S = "${WORKDIR}/git"

PV = "1.0.0"

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} += " \
        /usr/lib/panorama/plugins/Panorama/Pandora/libpandora.so \
        /usr/lib/panorama/plugins/Panorama/Pandora/qmldir \
        /usr/lib/panorama/plugins/Panorama/PNDManagement/qmldir \
        /usr/lib/panorama/plugins/Panorama/PNDManagement/libpndmanagement.so \
        /usr/lib/panorama/plugins/Panorama/Settings/libsettings.so \
        /usr/lib/panorama/plugins/Panorama/Settings/qmldir \
        /usr/lib/panorama/plugins/Panorama/UI/libui.so \
        /usr/lib/panorama/plugins/Panorama/UI/qmldir \
        /usr/share/panorama/interfaces/PNDManager/* \
"

        
