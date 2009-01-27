inherit module

COMPATIBLE_MACHINE = "omap3-pandora"

SRCREV = "f768d7ee7914d13a4277270774417b5e0f367701"

SRC_URI = " \
	git://openpandora.org/pandora-wifi.git;protocol=git;branch=pandora \
"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = " \
		'KERNELVER=${KERNEL_VERSION}' \
		'LINUXSRC=${STAGING_KERNEL_DIR}' \
		'CC=${TARGET_PREFIX}' \
		'OS=${TARGET_OS}'"

KCFLAGS = "-D__KERNEL__ -DMODULE \
	   -I. -I${STAGING_KERNEL_DIR}/include \
	   ${CFLAGS}"

MAKE_TARGETS = "BUILD=debug ARCH=arm CROSS_COMPILE=${TARGET_PREFIX} KERNEL_DIR=${STAGING_KERNEL_DIR} OUTPUT_DIR=${S} AR=ar"
