require linux.inc

DESCRIPTION = "2.6.27 Linux kernel for the Pandora handheld console"
KERNEL_IMAGETYPE = "uImage"

COMPATIBLE_MACHINE = "omap3-pandora"

# ----- Revision 2 Boards -----

#GIT HEAD for Rev2 - Same as Rev3 without Batt Fuel Guage and Nub/Button changes.

#SRCREV = "45dce3afbd5c2d2af899ae7e7a107d01a5c15558"

#SRC_URI = " \
#           git://git.openpandora.org/pandora-kernel.git;protocol=git;branch=rev2 \
#"

# -----------------------------


# ----- Revision 3 > Boards -----

#GIT HEAD for Rev3 > (i.e. Shipping units) - Will run on Rev2 boards without Nubs and an incorrect Start button.

SRCREV = "e2eaf64e85e435bb2405bfe8ff6ec1c5aa39bda6"

SRC_URI = " \
           git://git.openpandora.org/pandora-kernel.git;protocol=git;branch=pandora-27-omap1 \
"          

# -------------------------------

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
           file://musb-rxtx.patch;patch=1 \
           file://0001-SDIO-patches-to-put-some-card-into-into-platform-dev.patch;patch=1 \
           file://0002-Add-a-very-basic-platform-driver-module-to-bring-up-.patch;patch=1 \
           file://0003-Remove-old-msm_wifi-hack-as-the-temp-platform-driver.patch;patch=1 \
"
	
S = "${WORKDIR}/git"
