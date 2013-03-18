DESCRIPTION = "Openpandora extra packages"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r3"

inherit packagegroup

RDEPENDS_${PN} = " \
        nano \
        lsof \
        hdparm \
        tmux \
        packagegroup-sdk-target \
        htop \
        libgles-omap3-x11demos \       
	wireless-tools \
	openal-soft \
	p7zip \
	elementary-icon-theme elementary-icon-theme-enable \
	systemd-analyze \
	terminus-font \	
	ttf-liberation-serif ttf-liberation-sans ttf-liberation-mono \
	ttf-dejavu-common ttf-dejavu-sans ttf-dejavu-serif ttf-dejavu-sans-mono \
	evince \
	midori \
	fbgrab \
	gnome-mplayer \
	tar \
	wget \
	libsdl libsdl-mixer libsdl-image libsdl-gfx libsdl-net libsdl-ttf \
"

