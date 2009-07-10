DESCRIPTION = "Task file for default GUI apps in the Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r0.1"

inherit task

RDEPENDS_${PN} = "\
        task-pandora-core \
        angstrom-x11-base-depends \
        angstrom-gpe-task-base angstrom-gpe-task-game angstrom-gpe-task-apps angstrom-gpe-task-settings \
        angstrom-zeroconf-audio \
        angstrom-led-config \ 
        angstrom-gnome-icon-theme-enable \
        gpe-scap \
        xterm xmms \
        firefox \
        swfdec-mozilla \
        abiword \
        claws-mail \
        evince \
        exhibit \
        pidgin \
        gnome-games \
        synergy \
	x11vnc angstrom-x11vnc-xinit \
        xmms \
        xterm \
        xtscal \
        matchbox-wm \
        matchbox-desktop matchbox-panel matchbox-panel-manager matchbox-panel-hacks \
        matchbox-keyboard matchbox-keyboard-applet matchbox-keyboard-im \
        matchbox-common matchbox-config-gtk \
        matchbox-terminal \
        matchbox-themes-gtk pandora-matchbox-gtk-theme \
        pcmanfm \
        ttf-liberation-sans ttf-liberation-serif ttf-liberation-mono \
        xauth xhost xset xrandr \
        xcursor-transparent-theme \
        settings-daemon \
        matchbox-applet-cards \
        matchbox-applet-inputmanager \
        matchbox-applet-volume \
        matchbox-applet-startup-monitor \
	connman-gnome \
        scummvm \
"
