DESCRIPTION = "Task file for the XFCE Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r38"

inherit task

ANGSTROM_EXTRA_INSTALL ?= ""

APPS = " \
  avahi-ui \
#  abiword \
  evince \
#  claws-mail \
  swfdec swfdec-gnome swfdec-mozilla \
#  gnumeric \   
  networkmanager network-manager-applet \ 
  vnc x11vnc angstrom-x11vnc-xinit \
  xchat \
#  xournal \
  arora \
"

BLUETOOTH_GUI = " \
  gnome-bluetooth \
"

IM_CLIENT = " \
#  pidgin \
#  libpurple-protocol-msn \
#  libpurple-protocol-yahoo \
#  libpurple-protocol-icq \
#  libpurple-protocol-aim \
"

DISPMAN = " \
  slim \
  slim-op-themes \
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

# Any default games we want to ship.
GAMES = " \
#  scummvm \
#  frozen-bubble \
#  gnome-games \  
#  numptyphysics \
"

GNOME_APPS = " \
#  gnome-mplayer \
  gcalctool \ 
  gnome-keyring gnome-keyring-pam-plugin \
  gksu \
"

GSTREAMER = " \
#  gstreamer-ti \
  gst-ffmpeg \
  gst-omapfb \
#  gst-plugin-pulse \
  gst-plugin-xvimagesink \
  gst-plugins-base-meta \
#  gst-plugins-good-meta \
#  gst-plugins-bad-meta \
#  gst-plugins-ugly-meta \
  gst-plugin-gles \
"

ICON_THEME = " \
  hicolor-icon-theme \
  elementary-icon-theme \
  elementary-icon-theme-enable \
"

LAUNCHERS = " \
#  netbook-launcher-efl \
  pandora-libpnd-minimenu \
  pandora-pmenu \
"

PANDORA = " \
  pandora-first-run-wizard hsetroot \
  pandora-scripts \
  pandora-wallpaper-official pandora-wallpaper-community \
  pandora-xfce-defaults \
  pandora-midori-defaults midori \
  libgles2d \
  pandora-misc \
"

PERL = " \
  perl \
  task-perl-module-all \
  libnet-dbus-perl \
  libxml-parser-perl \
  libxml-twig-perl \
"

PULSEAUDIO = " \
#  pulseaudio-alsa-wrapper \
#  pulseaudio-esd-wrapper \
#  pulseaudio-module-gconf \
#  libasound-module-ctl-pulse \
#  libasound-module-pcm-pulse \
"

PYTHON_LIBS = " \
  python-shell \
  python-pygtk \
  python-pycairo \
  gnome-vfs-plugin-http \
  gnome-vfs-plugin-ftp \
"

QT_SELECTED = " qt4-x11-free \
"
# qt4-x11-free"
# qt4-x11-free-gles"

#PREFERRED_PROVIDER_qt4-x11-free = "${QT_SELECTED}"

QT_SUPPORT = " \
  ${QT_SELECTED} \
  qt4-plugin-imageformat-jpeg \
  qt4-plugin-imageformat-gif \
"

# We want all of the Qt metapackage (for dev use) without the demos/examples.
BAD_RRECOMMENDS += " \
  ${QT_SELECTED}-demos \
  ${QT_SELECTED}-examples \
"

TOTEM = " \
#  totem \
#  totem-browser-plugin \
#  totem-plugin-bemused \
#  totem-plugin-gromit \
#  totem-plugin-media-player-keys \
#  totem-plugin-ontop \
#  totem-plugin-properties \
#  totem-plugin-screensaver \
#  totem-plugin-skipto \
#  totem-plugin-thumbnail \
"

TOUCHSCREEN = " \
  gtk-touchscreen-mode-enable \
  libgtkstylus \
#  xinput-calibrator \
"

XFCE46_BASE = " \
  xfce4-dev-tools \
  xfwm4 \
  xfwm4-theme-default \
  xfce-utils \  
  xfce4-session \     
  xfconf \
  xfdesktop \
  xfce4-panel \
  xfce4-power-manager \
  \
  gtk-xfce-engine \
  \
  xfce4-panel-plugin-actions \
  xfce4-panel-plugin-clock \
  xfce4-panel-plugin-iconbox \
  xfce4-panel-plugin-launcher \
  xfce4-panel-plugin-pager \
  xfce4-panel-plugin-separator \
  xfce4-panel-plugin-showdesktop \
  xfce4-panel-plugin-systray \
  xfce4-panel-plugin-tasklist \
  xfce4-panel-plugin-windowlist \   
  xfce4-settings \
  xfce-terminal \
  thunar \
"

XFCE46_EXTRAS = " \
  xfce4-notifyd \
  xfce4-mixer \
  xfce4-appfinder \
  xfce4-battery-plugin \
  xfprint \    
  orage \
  squeeze \
  ristretto \
  mousepad \ 
  gigolo \
"

XFCE_THEMES = " \
  xfwm4-theme-daloa \
  xfwm4-theme-moheli \
  xfwm4-theme-kokodi \
  xfwm4-theme-sassandra \
  xfwm4-themes \
"

XSERVER_BASE = " \
  ${XSERVER} \
  dbus-x11 \
  desktop-file-utils \
  iso-codes \
  mime-support \
  notification-daemon inotify-tools \
  xauth \
  xdg-utils \
  xhost \
  xinetd \
  xinit \
  xlsfonts \
  xrdb \
  xrefresh \
  xset \
  xvinfo \
  devilspie \
  encodings \
  xterm \
  xmodmap \
"

RDEPENDS_${PN} = " \
  task-pandora-core \
  angstrom-x11-base-depends \
  ${ANGSTROM_EXTRA_INSTALL} \
  ${APPS} \
  ${BLUETOOTH_GUI} \
  ${IM_CLIENT} \
  ${DISPMAN} \
  ${FONTS} \
  ${GAMES} \  
  ${GNOME_APPS} \
  ${GSTREAMER} \
  ${ICON_THEME} \
  ${LAUNCHERS} \
  ${PANDORA} \
  ${PERL} \
  ${PULSEAUDIO} \
  ${PYTHON_LIBS} \
  ${QT_SUPPORT} \
  ${TOTEM} \
  ${TOUCHSCREEN} \
  ${XSERVER_BASE} \
  ${XFCE46_BASE} \
  ${XFCE46_EXTRAS} \
  ${XFCE_THEMES} \
  \
  rxvt-unicode \
#  xst \
#  suspend-desktop \
#  teleport \
  gdk-pixbuf-loader-png \
  gdk-pixbuf-loader-xpm \
  gdk-pixbuf-loader-jpeg \
  pango-module-basic-x \
  pango-module-basic-fc \
  xcursor-transparent-theme \	
  xterm \
  jaaa nmap iperf \
#  gnuplot \
"
