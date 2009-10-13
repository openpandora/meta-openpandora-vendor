DESCRIPTION = "Task file for the 'desktop' Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r1.1"

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

E17 = " \
  e-wm \
  places \
  e-wm-config-angstrom e-wm-config-angstrom-touchscreen e-wm-config-angstrom-widescreen e-wm-config-default \
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
#  gst-plugins-ugly-meta \
"

PERL = " \
  perl \
#  task-perl-module-all \
#  libnet-dbus-perl \
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
#  xdg-utils \
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
  ${E17} \
  ${FONTS} \
  ${GSTREAMER} \
  ${PERL} \
  ${PULSEAUDIO} \
  ${XSERVER_BASE} \
	angstrom-x11-base-depends \
	angstrom-gpe-task-base angstrom-gpe-task-settings \
	angstrom-zeroconf-audio \
	angstrom-led-config \ 
	gpe-scap \
	mime-support \
	xterm xmms \
	firefox midori \
	gecko-mediaplayer-firefox-hack \
	hicolor-icon-theme gnome-icon-theme \
	jaaa nmap iperf gnuplot \
	abiword \
	gnumeric \
	gimp \
	pidgin \
	gnome-games \
	stalonetray \
	synergy \
	x11vnc angstrom-x11vnc-xinit \
	angstrom-gnome-icon-theme-enable \
#	connman-gnome \
	networkmanager network-manager-applet \
	gnome-bluetooth \
"
