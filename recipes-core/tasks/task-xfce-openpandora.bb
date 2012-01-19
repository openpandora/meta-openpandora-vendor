DESCRIPTION = "Task file for the Xfce GUI OpenPandora image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

# Don't forget to bump the PR if you change it.
PR = "r3"

inherit task

ANGSTROM_EXTRA_INSTALL ?= ""

APPS = " \
  avahi-ui \
  evince \
  networkmanager network-manager-applet \ 
"

BLUETOOTH_GUI = " \
  gnome-bluetooth \
"

IM_CLIENT = " \
  pidgin \
"

DISPMAN = " \
  slim \
  pandora-slim-themes \
"

FONTS = " \
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
"

GNOME_APPS = " \
  gnome-keyring \
"

GSTREAMER = " \
  gst-ffmpeg \
  gst-plugins-base-meta \
"

ICON_THEME = " \
  hicolor-icon-theme \
  elementary-icon-theme \
  elementary-icon-theme-enable \
"

LAUNCHERS = " \
  pandora-libpnd-minimenu \
"

PANDORA = " \
  pandora-first-run-wizard hsetroot \
  pandora-scripts \
  pandora-wallpaper-official \
  pandora-xfce-defaults \
  pandora-midori-defaults midori \
  pandora-misc \
"

PERL = " \
  perl \
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

QT_SUPPORT = " \
  ${QT_SELECTED} \
  qt4-plugin-imageformat-jpeg \
  qt4-plugin-imageformat-gif \
"

# We want all of the Qt metapackage (for dev use) without the demos/examples.
BAD_RECOMMENDATIONS += " \
  qt4-demos \
  qt4-examples \
"

TOUCHSCREEN = " \
  gtk-touchscreen-mode-enable \
  libgtkstylus pointercal-xinput \
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
  \
  gtk-xfce-engine \
  \
  xfce4-panel-plugin-actions \
  xfce4-panel-plugin-clock \
  xfce4-panel-plugin-launcher \
  xfce4-panel-plugin-pager \
  xfce4-panel-plugin-separator \
  xfce4-panel-plugin-showdesktop \
  xfce4-panel-plugin-systray \
  xfce4-panel-plugin-tasklist \ 
  xfce4-settings \
  xfce-terminal \
  thunar \
"

XFCE46_EXTRAS = " \
  xfce4-notifyd \
  xfce4-appfinder \
  ristretto \
"

XFCE_THEMES = " \
  xfwm4-theme-daloa \
  xfwm4-theme-moheli \
  xfwm4-theme-kokodi \
  xfwm4-theme-sassandra \
"

XSERVER_BASE = " \
  ${XSERVER} \
  dbus-x11 \
  desktop-file-utils \
  iso-codes \
  mime-support \
  xauth \
  xdg-utils \
  xhost \
  xinetd \
  xinit \
  xrdb \
  xset \
  xvinfo \
  encodings \
  xterm \
  xmodmap \
  xinput \
  xcursor-transparent-theme \
  xterm \
  xdotool \
"

ADD_LIBS = " \
  libbonobo \
  libgsf \
  libidn \
  wv \
  libsamplerate0 \
  glibc-gconv-cp1252 \
  glibc-gconv-ibm850 \
  glibc-gconv-iso8859-15 \
"

RDEPENDS_${PN} = " \
  task-core-openpandora \
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
  ${PYTHON_LIBS} \
  ${QT_SUPPORT} \
  ${TOUCHSCREEN} \
  ${XSERVER_BASE} \
  ${XFCE46_BASE} \
  ${XFCE46_EXTRAS} \
  ${XFCE_THEMES} \
  ${ADD_LIBS} \
  \
  rxvt-unicode \
  gdk-pixbuf-loader-png \
  gdk-pixbuf-loader-xpm \
  gdk-pixbuf-loader-jpeg \
  pango-module-basic-x \
  pango-module-basic-fc \
  iperf \
"
