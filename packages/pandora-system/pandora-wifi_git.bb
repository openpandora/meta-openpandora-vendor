DESCRIPTION = "Kernel drivers for the TI1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

PR = "r8"

# Check the include for the source location/GIT SRCREV etc.
require pandora-wifi.inc

do_compile_prepend() {
	cd ${S}/sta_dk_4_0_4_32/
}

do_install() {
	cd ${S}/sta_dk_4_0_4_32/
	mkdir -p ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net
	cp ${S}/sta_dk_4_0_4_32/*.ko ${D}/lib/modules/${KERNEL_VERSION}/kernel/drivers/net
}
