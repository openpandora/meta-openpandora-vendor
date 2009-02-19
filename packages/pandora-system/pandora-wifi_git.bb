DESCRIPTION = "Kernel drivers for the TI1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

PR = "r9"

# Check the include for the source location/GIT SRCREV etc.
require pandora-wifi.inc

SRC_URI += " \
	file://rc.tiwifi \
"

inherit update-rc.d

INITSCRIPT_NAME = "tiwifi-init"
INITSCRIPT_PARAMS = "start 30 5 2 . stop 40 0 1 6 ."

do_compile_prepend() {
          cd ${S}/sta_dk_4_0_4_32/
}

do_install() {
          cd ${S}/sta_dk_4_0_4_32/
          mkdir -p ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net
          cp ${S}/sta_dk_4_0_4_32/*.ko ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net
          install -d ${D}${sysconfdir}/init.d/
          cp -pP ${WORKDIR}/rc.tiwifi ${D}${sysconfdir}/init.d/tiwifi-init
}

FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/kernel/drivers/net/*.ko.*"