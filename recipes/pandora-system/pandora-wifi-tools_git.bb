DESCRIPTION = "Tools to support the TI1251 WiFi chip found on the Pandora - Connected via SDIO"
LICENSE = "GPLv2"

DEPENDS = "pandora-wifi"

# Check the include for the source location/GIT SRCREV etc.
require pandora-wifi.inc

SRC_URI += " \
	file://wlan_cu_makefile.patch;patch=1 \
	file://wlan_loader \
"

#
#make  CROSS_COMPILE=${KERNEL_PREFIX} CROSS_COMPILE=arm-none-linux-gnueabi- V=1 ARCH=arm KERNEL_DIR=/storage/file-store/Projects/Pandora/pandora-kernel.git OUTPUT_DIR=/storage/file-store/Projects/Pandora/pandora-wifi.git

do_compile_prepend() {
	cd ${S}/sta_dk_4_0_4_32/CUDK/CLI/
}

# Evil hack no. 42 - I really have no desire to try and clean up the build system for this anymore - DJW.
#CXX += " -Wall -Wstrict-prototypes -O0 -g -fno-builtin -DDEBUG -D TI_DBG   -D__LINUX__ -D __BYTE_ORDER_LITTLE_ENDIAN -D INCLUDE_DEFRAGMENTATION -D CONFIGURE_BSS_TYPE_STA -D TNETW1150=1 -D DOT11_A_G=1 -D ELP_NO_PDA_SCREEN_VIBRATE -mabi=aapcs-linux -DDRV_NAME='"tiwlan"' -DHOST_COMPILE -DFIRMWARE_DYNAMIC_LOAD -I. -I./../../common/inc -I./../../common/src/inc -I./../../common/src/utils -I./../../common/src/hal/inc -I./../../common/src/hal/hl_data -I./../../common/src/hal/hl_ctrl -I./../../common/src/hal/hw_data -I./../../common/src/hal/hw_ctrl -I./../../common/src/hal/security -I./../../common/src/core/inc -I./../../common/src/core/data_ctrl/Tx -I./../../common/src/core/data_ctrl/Ctrl -I./../../common/src/core/data_ctrl/Ctrl/4X -I./../../common/src/core/sme/Inc -I./../../common/src/core/sme/siteMgr -I./../../common/src/core/sme/configMgr -I./../../common/src/core/sme/conn -I./../../common/src/core/rsn -I./../../common/src/core/rsn/mainKeysSm -I./../../common/src/core/rsn/mainKeysSm/keyDerive -I./../../common/src/core/rsn/inc -I./../../common/src/core/mlme -I./../../common/src/core/NetworkCtrl/inc -I./../../common/src/core/NetworkCtrl/Measurement -I./../../common/src/core/NetworkCtrl/RegulatoryDomain -I./../../common/src/core/NetworkCtrl/QOS -I./../CLI -I./../UtilityAdapter -I./../../common/src/hal/FirmwareApi -I./../../common/src/hal/TnetwServices -I./../../common/src/hal/TnetwServices/TNETW1251 -I./../../pform/linux/inc -I./../Inc -I./../../pform/common/inc -I./../../CUDK/OAL/Common"
#CC += " -Wall -Wstrict-prototypes -O0 -g -fno-builtin -DDEBUG -D TI_DBG   -D__LINUX__ -D __BYTE_ORDER_LITTLE_ENDIAN -D INCLUDE_DEFRAGMENTATION -D CONFIGURE_BSS_TYPE_STA -D TNETW1150=1 -D DOT11_A_G=1 -D ELP_NO_PDA_SCREEN_VIBRATE -mabi=aapcs-linux -DDRV_NAME='"tiwlan"' -DHOST_COMPILE -DFIRMWARE_DYNAMIC_LOAD -I. -I./../../common/inc -I./../../common/src/inc -I./../../common/src/utils -I./../../common/src/hal/inc -I./../../common/src/hal/hl_data -I./../../common/src/hal/hl_ctrl -I./../../common/src/hal/hw_data -I./../../common/src/hal/hw_ctrl -I./../../common/src/hal/security -I./../../common/src/core/inc -I./../../common/src/core/data_ctrl/Tx -I./../../common/src/core/data_ctrl/Ctrl -I./../../common/src/core/data_ctrl/Ctrl/4X -I./../../common/src/core/sme/Inc -I./../../common/src/core/sme/siteMgr -I./../../common/src/core/sme/configMgr -I./../../common/src/core/sme/conn -I./../../common/src/core/rsn -I./../../common/src/core/rsn/mainKeysSm -I./../../common/src/core/rsn/mainKeysSm/keyDerive -I./../../common/src/core/rsn/inc -I./../../common/src/core/mlme -I./../../common/src/core/NetworkCtrl/inc -I./../../common/src/core/NetworkCtrl/Measurement -I./../../common/src/core/NetworkCtrl/RegulatoryDomain -I./../../common/src/core/NetworkCtrl/QOS -I./../CLI -I./../UtilityAdapter -I./../../common/src/hal/FirmwareApi -I./../../common/src/hal/TnetwServices -I./../../common/src/hal/TnetwServices/TNETW1251 -I./../../pform/linux/inc -I./../Inc -I./../../pform/common/inc -I./../../CUDK/OAL/Common"

#do_compile() {
#          oe_runmake 
#          cd ${S}/sta_dk_4_0_4_32/CUDK/tiwlan_loader
#          oe_runmake 
#}

do_install() {
	${TARGET_PREFIX}strip ${S}/wlan_cu
#	${TARGET_PREFIX}strip ${S}/sta_dk_4_0_4_32/CUDK/tiwlan_loader/wlan_loader
	install -d ${D}${bindir}
	install -m 0755 ${S}/wlan_cu ${D}${bindir}/tiwlan_cu
	install -m 0755 ${WORKDIR}/wlan_loader ${D}${bindir}/tiwlan_loader
}

FILES_${PN} += "${bindir} ${sbindir} ${bindir}/tiwlan_cu ${bindir}/tiwlan_loader"
