DESCRIPTION = "Kernel drivers for the TI1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

PR = "r9.2"

# Check the include for the source location/GIT SRCREV etc.
require pandora-wifi.inc

SRC_URI += " \
	file://rc.tiwifi \
#	file://0011-Add-in-the-start-of-wireless-extensions-support-ioc.patch;patch=1 \
"

inherit update-rc.d

INITSCRIPT_NAME = "tiwifi-init"
INITSCRIPT_PARAMS = "start 30 5 2 . stop 40 0 1 6 ."

do_compile_prepend() {
          cd ${S}/sta_dk_4_0_4_32/
}

do_install() {
          cd ${S}/sta_dk_4_0_4_32/
          mkdir -p ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/tiwlan
          cp ${S}/sta_dk_4_0_4_32/*.ko ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/tiwlan
          install -d ${D}${sysconfdir}/init.d/
          cp -pP ${WORKDIR}/rc.tiwifi ${D}${sysconfdir}/init.d/tiwifi-init
          cp -pP ${S}/sta_dk_4_0_4_32/fw/tiwlan.ini ${D}${sysconfdir}/tiwlan.ini         
}

FILES_${PN} += "/lib/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/tiwlan/*.ko.*"