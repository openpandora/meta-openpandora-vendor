FILESEXTRAPATHS := "${THISDIR}/${PN}"

PRINC := "${@int(PRINC) + 1}"

# OpenPandora patch to let the plugin read it's internal battery status. 
SRC_URI_append_openpandora = " file://xfce4-battery-plugin-1.0.5-pandora-hack.patch;patch=1"
PACKAGE_ARCH_openpandora = "${MACHINE_ARCH}"
