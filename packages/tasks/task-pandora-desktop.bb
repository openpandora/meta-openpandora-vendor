DESCRIPTION = "Task file for default GUI apps in the Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r3"

inherit task

ECONFIG ?= "e-wm-config-angstrom e-wm-config-default"

RDEPENDS_${PN} = "\
	task-pandora-core \
	${XSERVER} \
	angstrom-x11-base-depends \
	angstrom-gpe-task-base \
	angstrom-gpe-task-settings \
	angstrom-zeroconf-audio \
	angstrom-led-config \ 
	gpe-scap \
	mime-support e-wm ${ECONFIG} exhibit \
	xterm xmms \
	epiphany firefox midori \
	swfdec-mozilla \
	hicolor-icon-theme gnome-icon-theme \
	jaaa nmap iperf gnuplot \
	abiword \
	gnumeric \
	gimp \
	powertop oprofile \
	pidgin \
	mplayer \
	omapfbplay \
	gnome-games \
	stalonetray \
	synergy \
	x11vnc \
	angstrom-gnome-icon-theme-enable \	
#	network-manager-applet \
"
