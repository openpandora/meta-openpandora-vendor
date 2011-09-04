rDESCRIPTION = "Task file for default GUI apps in the Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r1"
LICENSE = "MIT"

inherit task

ANGSTROM_EXTRA_INSTALL ?= ""

APPS = " \
  abiword \
  cheese \
  claws-mail \
  epiphany epiphany-extensions \
  swfdec swfdec-gnome swfdec-mozilla \
  evince \
  gcalctool \
  gedit \
  gimp \
  gnome-games \
  gnome-mplayer \
  gnumeric \
  gphoto2 \
  gthumb \
  pidgin \
  synergy \
  vnc \
  x11vnc angstrom-x11vnc-xinit \
  xmms \
  xterm \
"

FONTS = " \
  font-adobe-75dpi \
  fontconfig fontconfig-utils font-util \
  ttf-arphic-uming \
  ttf-dejavu-common \
  ttf-dejavu-sans \
  ttf-dejavu-serif \
  ttf-dejavu-sans-mono \
  ttf-liberation-sans \
  ttf-liberation-serif \
  ttf-liberation-mono \
  xorg-minimal-fonts \
"  

GSTREAMER = " \
  gst-ffmpeg \
  gst-omapfb \
  gst-plugin-pulse \
  gst-plugins-base-meta \
  gst-plugins-good-meta \
  gst-plugins-bad-meta \
"

PERL = " \
  perl \
  libxml-parser-perl \
  libxml-twig-perl \
"

PULSEAUDIO = " \
  pulseaudio-alsa-wrapper \
  pulseaudio-esd-wrapper \
  pulseaudio-module-gconf \
  libasound-module-ctl-pulse \
  libasound-module-pcm-pulse \
"

XSERVER_BASE = " \
  ${XSERVER} \
  dbus-x11 \
  desktop-file-utils \
  iso-codes \
  mime-support \
  notification-daemon inotify-tools \
  xauth \
  xhost \
  xinetd \
  xinit \
  xlsfonts \
  xrdb \
  xrefresh \
  xset \
  xvinfo \
"

RDEPENDS_${PN} = " \
  task-pandora-core \
  ${ANGSTROM_EXTRA_INSTALL} \
  ${APPS} \
  ${FONTS} \
  ${GSTREAMER} \
  ${PERL} \
  ${PULSEAUDIO} \
  ${XSERVER_BASE} \
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
        pidgin \
        gnome-games \
        synergy \
	x11vnc angstrom-x11vnc-xinit \
        xmms \
        xterm \
        xtscal \
        matchbox2 \
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
	networkmanager \
        scummvm \
	gnome-bluetooth \
"
