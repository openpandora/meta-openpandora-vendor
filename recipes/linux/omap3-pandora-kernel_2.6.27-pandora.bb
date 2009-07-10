require linux.inc

DESCRIPTION = "2.6.27 Linux kernel for the Pandora handheld console"
KERNEL_IMAGETYPE = "uImage"

COMPATIBLE_MACHINE = "omap3-pandora"

#GIT HEAD for Rev2
SRCREV = "7aeecd01683d0b1087122d442346b2945c480cf7"

#Rev2
SRC_URI = " \
           git://git.openpandora.org/pandora-kernel.git;protocol=git;branch=pandora-27-omap1 \
"


#GIT HEAD for Rev3
#SRCREV = "4162fb142cd8d5a435b69fa44d6b1eec349420c9"

#Rev3
#SRC_URI = " \
#           git://git.openpandora.org/pandora-kernel.git;protocol=git;branch=rev3 \
#"          

PV = "2.6.27-pandora+${PR}+git${SRCREV}"

SRC_URI_append = " \
           file://defconfig \
           file://0001-Add-EHCI-patch-suggested-by-Steven-Kipisz.patch;patch=1 \
           file://0002-Add-missing-define-to-EHCI-OMAP.c.patch;patch=1 \
           file://no-empty-flash-warnings.patch;patch=1 \
           file://oprofile-0.9.3.armv7.diff;patch=1 \
           file://no-cortex-deadlock.patch;patch=1 \
           file://read_die_ids.patch;patch=1 \
           file://fix-install.patch;patch=1 \
           file://musb-dma-iso-in.eml;patch=1 \
           file://musb-support-high-bandwidth.patch.eml;patch=1 \
           file://mru-fix-timings.diff;patch=1 \
           file://mru-fix-display-panning.diff;patch=1 \
           file://mru-make-dpll4-m4-ck-programmable.diff;patch=1 \
           file://mru-improve-pixclock-config.diff;patch=1 \
           file://mru-make-video-timings-selectable.diff;patch=1 \
           file://mru-enable-overlay-optimalization.diff;patch=1 \
           file://musb-fix-ISO-in-unlink.diff;patch=1 \
           file://musb-fix-multiple-bulk-transfers.diff;patch=1 \
           file://musb-fix-endpoints.diff;patch=1 \
           file://dvb-fix-dma.diff;patch=1 \
           file://0001-Removed-resolution-check-that-prevents-scaling-when.patch;patch=1 \
           file://0001-Implement-downsampling-with-debugs.patch;patch=1 \
           file://sitecomwl168-support.diff;patch=1 \
#	file://pvr/dispc.patch;patch=1 \
           file://musb-rxtx.patch;patch=1 \
#	file://0001-implement-TIF_RESTORE_SIGMASK-support-and-enable-the.patch;patch=1 \
           file://0001-SDIO-patches-to-put-some-card-into-into-platform-dev.patch;patch=1 \
"
	
S = "${WORKDIR}/git"
