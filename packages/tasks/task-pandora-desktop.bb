DESCRIPTION = "Task file for the 'desktop' Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r1.6"

inherit task

ECONFIG ?= "places e-wm-config-angstrom e-wm-config-default"

RDEPENDS_${PN} = "\
	task-pandora-core \
	angstrom-x11-base-depends \
        angstrom-gpe-task-base angstrom-gpe-task-game angstrom-ohand-task-pim angstrom-gpe-task-apps angstrom-gpe-task-settings \
	angstrom-zeroconf-audio \
	angstrom-led-config \ 
	gpe-scap \
	mime-support e-wm ${ECONFIG} exhibit \
	xterm xmms \
	firefox midori \
	swfdec-mozilla \
	hicolor-icon-theme gnome-icon-theme \
	jaaa nmap iperf gnuplot \
	abiword \
	gnumeric \
	gimp \
	powertop oprofile \
	pidgin \
	gnome-games \
	stalonetray \
	synergy \
	x11vnc angstrom-x11vnc-xinit \
	angstrom-gnome-icon-theme-enable \
	connman-gnome \
#	networkmanager-applet \
	scummvm \
	ogre-egl \
"
