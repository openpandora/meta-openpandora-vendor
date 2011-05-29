require u-boot.inc

COMPATIBLE_MACHINE = "omap3-pandora"

# Latest SRCREV.
SRCREV = "48aa0d1c545b4085435577602f331e07c097782f"

PV = "pandora+${PR}+gitr${SRCREV}"
PR ="r9"
PE = "1"

SRC_URI = "git://git.openpandora.org/pandora-u-boot.git;branch=master;protocol=git \
"

UBOOT_MACHINE_omap3-pandora = "omap3_pandora_config"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"
