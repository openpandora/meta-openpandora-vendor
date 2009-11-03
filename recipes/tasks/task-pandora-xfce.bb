DESCRIPTION = "Task file for the XFCE Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r6.1"

inherit task

ANGSTROM_EXTRA_INSTALL ?= ""

APPS = " \
  avahi-ui \
  abiword \
  claws-mail \
  swfdec swfdec-gnome swfdec-mozilla \
  firefox \
  gnumeric \   
  gimp \
  networkmanager network-manager-applet \ 
  synergy \
  vnc \
  x11vnc angstrom-x11vnc-xinit \
  xmms \
  xterm \
"

IM_CLIENT = " \
  pidgin \
  libpurple-protocol-msn \
  libpurple-protocol-yahoo \
  libpurple-protocol-icq \
  libpurple-protocol-aim \
"

DISPMAN = " \
  slim \
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

GNOME_APPS = " \
#  epiphany epiphany-extensions \
#  evince \  
  gnome-games \
  gnome-mplayer \
  gcalctool \ 
  gnome-bluetooth \	
  gnome-keyring gnome-keyring-pam-plugin \
"

GNOME_GTK = " \
#  hicolor-icon-theme \
#  gnome-icon-theme \
#  angstrom-gnome-icon-theme-enable \
"

GSTREAMER = " \
  gst-ffmpeg \
  gst-omapfb \
  gst-plugin-pulse \
  gst-plugins-base-meta \
#  gst-plugins-good-meta \
  gst-plugins-bad-meta \
#  gst-plugins-ugly-meta \
"

ICON_THEME = " \
  tango-icon-theme \
  tango-icon-theme-enable \
"

PERL = " \
  perl \
  task-perl-module-all \
  libnet-dbus-perl \
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

TOTEM = " \
  totem \
  totem-browser-plugin \
  totem-plugin-bemused \
  totem-plugin-gromit \
  totem-plugin-media-player-keys \
  totem-plugin-ontop \
  totem-plugin-properties \
  totem-plugin-screensaver \
  totem-plugin-skipto \
  totem-plugin-thumbnail \
"

TOUCHSCREEN = " \
#  xf86-input-evtouch \
  xf86-input-tslib \
  gtk-touchscreen-mode-enable \
  libgtkstylus \
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
  xfprint \    
  midori \
  orage \
  squeeze \
  ristretto \
  mousepad \ 
  gigolo \
"

XFCE_THEMES = " \
  xfwm4-theme-daloa \
  xfwm4-theme-moheli \
  xfwm4-theme-default-4.0 \
  xfwm4-theme-default-4.2 \
  xfwm4-theme-default-4.4 \
  xfwm4-theme-kokodi \
  xfwm4-theme-moheli \
  xfwm4-theme-sassandra \
  xfwm4-theme-stoneage \
  xfwm4-theme-therapy \
  xfwm4-theme-tyrex \
  xfwm4-theme-wallis \  
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
"

RDEPENDS_${PN} = " \
  task-pandora-core \
  angstrom-x11-base-depends \
  ${ANGSTROM_EXTRA_INSTALL} \
  ${APPS} \
  ${IM_CLIENT} \
  ${DISPMAN} \
  ${FONTS} \
  ${GNOME_GTK} \
  ${GNOME_APPS} \
  ${GSTREAMER} \
  ${ICON_THEME} \
  ${PERL} \
  ${PULSEAUDIO} \
  ${TOTEM} \
  ${TOUCHSCREEN} \
  ${XSERVER_BASE} \
  ${XFCE46_BASE} \
  ${XFCE46_EXTRAS} \
  ${XFCE_THEMES} \
  \
#	pandora-auto-startx \
  pandora-first-run-wizard \
  \
  rxvt-unicode \
  xst \
  suspend-desktop \
  teleport \
  gdk-pixbuf-loader-png \
  gdk-pixbuf-loader-xpm \
  gdk-pixbuf-loader-jpeg \
  pango-module-basic-x \
  pango-module-basic-fc \
  xcursor-transparent-theme \	
  mime-support \
  xterm xmms \
  jaaa nmap iperf gnuplot \
  x11vnc angstrom-x11vnc-xinit \
"
