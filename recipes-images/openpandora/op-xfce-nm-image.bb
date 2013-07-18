require recipes-images/angstrom/systemd-image.bb

CONMANPKGS = "networkmanager network-manager-applet modemmanager"

IMAGE_INSTALL += " \
	packagegroup-xfce-base \
	packagegroup-xfce-extended \
	packagegroup-gnome-xserver-base \
	packagegroup-core-x11-xserver \
	packagegroup-gnome-fonts \
	angstrom-gnome-icon-theme-enable gtk-engine-clearlooks gtk-theme-clearlooks angstrom-clearlooks-theme-enable \
	packagegroup-openpandora-core \
	packagegroup-openpandora-extra \
"

export IMAGE_BASENAME = "OP-XFCE-NetworkManager-image"

