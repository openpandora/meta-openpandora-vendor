DESCRIPTION = "Task file for default GUI apps in the Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r6"

inherit task

ECONFIG ?= "e-wm-config-standard e-wm-config-default"

RDEPENDS_${PN} = "\
	task-pandora-core \
	${XSERVER} \
	angstrom-x11-base-depends \
	pointercal \
	matchbox-wm \
	matchbox-keyboard matchbox-keyboard-applet matchbox-keyboard-im \
	matchbox-desktop \
	ttf-liberation-sans ttf-liberation-serif ttf-liberation-mono \
	xauth xhost xset xrandr \
	matchbox-sato \
	matchbox-config-gtk \
	matchbox-themes-gtk \
	matchbox-applet-startup-monitor \
	matchbox-panel-manager \
	xcursor-transparent-theme \
	sato-icon-theme \
	settings-daemon \
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
	mplayer omapfbplay \
	gnumeric \
"
