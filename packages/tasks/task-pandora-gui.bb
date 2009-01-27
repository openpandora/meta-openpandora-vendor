DESCRIPTION = "Task file for default GUI apps in the Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r6"

inherit task

RDEPENDS_${PN} = "\
	task-pandora-core \
	${XSERVER} \
	angstrom-x11-base-depends \
	angstrom-gpe-task-base \
	angstrom-gpe-task-settings \
	abiword \
	claws-mail \
	evince \
	exhibit \
	epiphany firefox midori \
	swfdec-mozilla \
	omapfbplay \
	pidgin \
	synergy \
	vnc \
	x11vnc \
	xmms \
	xterm \
	xtscal \
	alsa-utils \
	alsa-utils-alsactl \
	alsa-utils-alsamixer \
	alsa-utils-aplay \
	pointercal \
	matchbox-wm \
	matchbox-keyboard matchbox-keyboard-applet matchbox-keyboard-im \
	matchbox-desktop \
	matchbox-common \
	matchbox-config-gtk \
	matchbox-themes-gtk \
	matchbox-panel-manager \
	matchbox-panel-hacks \
	ttf-liberation-sans ttf-liberation-serif ttf-liberation-mono \
	xauth xhost xset xrandr \
	xcursor-transparent-theme \
	settings-daemon \
	mplayer \
	omapfbplay \
	matchbox-applet-cards \
	matchbox-applet-inputmanager \
	matchbox-applet-volume \
	matchbox-applet-startup-monitor \	
#	network-manager-applet \
"
