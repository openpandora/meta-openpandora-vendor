DESCRIPTION = "Openpandora core pacakges"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r8"

inherit packagegroup

RDEPENDS_${PN} = " \
        slim \
        pam-plugin-mkhomedir libpam-xtests \
        aufs-util \
        util-linux \
        bzip2 \
        squashfs-tools \
	e2fsprogs e2fsprogs-mke2fs dosfstools \
        libgles-omap3 \
	libgles-omap3-es2 libgles-omap3-es3 libgles-omap3-es5 libgles-omap3-es6 \
        udev-extraconf \
        util-linux-blkid \
        openpandora-first-run-wizard \
        openpandora-sudoers \
        openpandora-configtray openpandora-configtray-wifi \
        openpandora-scripts openpandora-scripts-wifi \
        openpandora-libpnd \
        openpandora-misc \
        openpandora-state \
        openpandora-xfce-defaults \
	openpandora-compat \
	openpandora-modules-load \
	sudo-enable-wheel-group \
	libxxf86vm \
	mtd-utils \
	led-config \
	wl1251-init \
"

