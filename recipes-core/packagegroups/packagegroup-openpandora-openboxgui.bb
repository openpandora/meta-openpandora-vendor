DESCRIPTION = "Openpandora packages for switchgui openbox"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58"

PR = "r1"

inherit packagegroup

RDEPENDS_${PN} = " \
		xprop \
		openbox \
		gtk-chtheme \
		lxterminal \
		menu-cache \
		obconf \
		openbox-menu \
		switchgui-openbox \
		tint2 \
		wbar \
		mousepad \
		xdotool \
		gtk-theme-clearlooks \
		gtk-theme-crux \
		gtk-theme-industrial \
		gtk-theme-mist \
		gtk-theme-redmond \
		gtk-theme-thinice \
		openbox-theme-artwiz-boxed \
		openbox-theme-bear2 \
		openbox-theme-clearlooks-3.4 \
		openbox-theme-clearlooks \
		openbox-theme-clearlooks-olive \
		openbox-theme-mikachu \
		openbox-theme-natura \
		openbox-theme-onyx \
		openbox-theme-onyx-citrus \
		openbox-theme-orang \
		openbox-theme-syscrash \
        libxinerama \
"

