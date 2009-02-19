DESCRIPTION = "Task file for default GUI apps in the Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r1.4"

inherit task

RDEPENDS_${PN} = "\
        task-pandora-core \
        angstrom-x11-base-depends \
        angstrom-gpe-task-base angstrom-gpe-task-game angstrom-ohand-task-pim angstrom-gpe-task-apps angstrom-gpe-task-settings \
        angstrom-zeroconf-audio \
        angstrom-led-config \ 
        angstrom-gnome-icon-theme-enable \
        gpe-scap \
        xterm xmms \
        firefox midori \
        swfdec-mozilla \
        abiword \
        claws-mail \
        evince \
        exhibit \
        pidgin \
        gnome-games \
        synergy \
        vnc \
        x11vnc \
        xmms \
        xterm \
        xtscal \
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
        matchbox-applet-cards \
        matchbox-applet-inputmanager \
        matchbox-applet-volume \
        matchbox-applet-startup-monitor \
        connman-gnome \
#	networkmanager-applet \
        scummvm \
"
