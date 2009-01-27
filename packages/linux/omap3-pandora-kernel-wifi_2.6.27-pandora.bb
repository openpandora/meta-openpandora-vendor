require linux.inc

DESCRIPTION = "Test WiFi 2.6.27 Linux kernel for the Pandora handheld console"
KERNEL_IMAGETYPE = "uImage"

COMPATIBLE_MACHINE = "omap3-pandora"

SRCREV = "5f34ff5fc9e4acd56344552dd15ca6aa4c689fc8"

#PV = "2.6.27-pandora+git${SRCREV}"
PR = "r1"

SRC_URI = " \
	git://openpandora.org/pandora-kernel.git;protocol=git;branch=test_wifi \
	file://defconfig \
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
	file://mru-add-clk-get-parent.diff;patch=1 \
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
#	file://pvr/pvr-add.patch;patch=1 \
	file://pvr/dispc.patch;patch=1 \
#	file://pvr/nokia-TI.diff;patch=1 \
"
	
S = "${WORKDIR}/git"

#do_configure_prepend() {
#	install -m 0644 ${S}/arch/arm/configs/omap3_pandora_defconfig ${WORKDIR}/defconfig
#}
