SRC_URI = " \
          git://openpandora.org/pandora-wifi.git;protocol=git;branch=pandora \
"

SRCREV = "f768d7ee7914d13a4277270774417b5e0f367701"

S = "${WORKDIR}/git"

inherit module

PARALLEL_MAKE = ""

EXTRA_OEMAKE = " \
          'KERNELVER=${KERNEL_VERSION}' \
          'LINUXSRC=${STAGING_KERNEL_DIR}' \
          'KERNEL_DIR=${STAGING_KERNEL_DIR}' \
          'CROSS_COMPILE=${TARGET_PREFIX}' \
          'CC=${TARGET_PREFIX}' \
          'OS=${TARGET_OS}' \
          'WSPI=n' \
          'ARCH=arm' \
          'DV_KERNEL_BASELINE_IS=baseline2' \
          'OUTPUT_DIR=${S}' \
          'AR=ar' \
          "

COMPATIBLE_MACHINE = "omap3-pandora"

#Warning: Here be hacks as the build system is a little nuts.
MAKE_TARGETS = "BUILD=debug ARCH=arm CROSS_COMPILE=${TARGET_PREFIX} KERNEL_DIR=${STAGING_KERNEL_DIR} OUTPUT_DIR=${S} AR=ar"

KCFLAGS = "-D__KERNEL__ -DMODULE \
          -I. -I${STAGING_KERNEL_DIR}/include \
          ${CFLAGS}"
