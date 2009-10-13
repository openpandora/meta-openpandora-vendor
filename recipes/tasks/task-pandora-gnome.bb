DESCRIPTION = "Task file for the 'gnome' Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r3.1"

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

GNOME = " \
  at-spi \
  file-roller \
  gconf gconf-editor \
  gdm \
  gnome-control-center \
  gnome-applets \
  gnome-bluetooth \
  gnome-desktop \
  gnome-doc-utils \
  gnome-keyring gnome-keyring-pam-plugin \
  gnome-media \
  gnome-menus \
  gnome-mime-data \
#  gnome-packagekit packagekit packagekit-gtkmodule \
  gnome-panel libpanel-applet libgweather-locationdata\
  gnome-power-manager gnome-power-manager-applets \
  gnome-python \
# gnome-python-extras \
  gnome-python-desktop \
  gnome-screensaver \
  gnome-session \
  gnome-settings-daemon \
  gnome-system-monitor \
#  gnome-system-tools system-tools-backends\
  gnome-terminal \
#  gnome-utils \
  gnome-vfs \
  gnome-vfs-plugin-bzip2 \
  gnome-vfs-plugin-computer \
  gnome-vfs-plugin-dns-sd \
  gnome-vfs-plugin-file \
  gnome-vfs-plugin-ftp \
  gnome-vfs-plugin-gzip \
  gnome-vfs-plugin-http \
  gnome-vfs-plugin-network \
  gnome-vfs-plugin-nntp \
  gnome-vfs-plugin-sftp \
  gnome-vfs-plugin-tar \
  gvfs \
  metacity \
  nautilus nautilus-cd-burner desktop-file-utils\
  networkmanager network-manager-applet \
#networkmanager-openvpn \
  policykit-gnome policykit \
  zenity \
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

UIM = " \
  uim \
  uim-common \
  uim-utils \
  uim-gtk2.0 \
  uim-anthy \
  uim-fep \
  uim-skk \
  uim-xim \
"

PERL = " \
  perl \
#  task-perl-module-all \
#  libnet-dbus-perl \
  libxml-parser-perl \
  libxml-twig-perl \
"

PRINT = " \
  cups \
  cups-backend-hal \
#  cups-gs \
  gnome-cups-manager \
  gtk-printbackend-cups \
#  gutenprint \
  hal-cups-utils \
"

PULSEAUDIO = " \
  pulseaudio-alsa-wrapper \
  pulseaudio-esd-wrapper \
  pulseaudio-module-gconf \
  libasound-module-ctl-pulse \
  libasound-module-pcm-pulse \
"

THEMES = " \
  gnome-icon-theme \
  gnome-themes \
  gtk-engine-clearlooks \
  gtk-engine-glide \
  gtk-engine-thinice \
  gtk-engine-redmond95 \
  gtk-theme-clearlooks \
  gtk-theme-thinice \
  gtk-theme-redmond \
  hicolor-icon-theme \
#  sound-theme-freedesktop \
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
  ${FONTS} \
  ${GNOME} \
  ${GSTREAMER} \
  ${PERL} \
  ${PRINT} \
  ${PULSEAUDIO} \
  ${THEMES} \
  ${TOTEM} \
  ${XSERVER_BASE} \
"
