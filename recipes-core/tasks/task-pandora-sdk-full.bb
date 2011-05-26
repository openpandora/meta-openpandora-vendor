DESCRIPTION = "OpenPandora: Full SDK development packages"

ALLOW_EMPTY = "1"

PR = "r4"

DEPENDS = "task-pandora-sdk-base"

RDEPENDS = "\
  task-pandora-sdk-base \
"

# Ensure all SDL dev libs are packaged.
RDEPENDS += "\
  libsdl-x11-dev \
  libsdl-gfx-dev \
  libsdl-image-dev \
  libsdl-mixer-dev \
  libsdl-ttf-dev \
  libsdl-net-dev \
"

# Media libs.
RDEPENDS += "\
  libmodplug-dev \
  faad2-dev \
  mikmod-dev \
  speex-dev \  
  flac-dev \  
  libmad-dev \
"

# OpenPandora specific stuff.
RDEPENDS += "\
  pandora-libpnd-dev \
  pandora-libpnd-doc \
  libgles2d \
  libgles2d-dev \  
"

# Boost Development libs.
RDEPENDS += "\
  boost-dev \
"

# OMAP3/SGX libs.
RDEPENDS += "\
  libgles-omap3 \
  libgles-omap3-dev \
"

# QT4 libs.
RDEPENDS += "\
  qt4-x11-free-dev \
  qt4-mkspecs \
  libqt-phonon4-dev \
  libqt-3support4-dev \
  libqt-assistantclient4-dev \
  libqt-clucene4-dev \
  libqt-core4-dev \
  libqt-dbus4-dev \
  libqt-designercomponents4-dev \
  libqt-designer4-dev \
  libqt-uitools4-dev \
  libqt-gui4-dev \
  libqt-help4-dev \
  libqt-network4-dev \
  libqt-script4-dev \
  libqt-scripttools4-dev \
  libqt-sql4-dev \
  libqt-svg4-dev \
  libqt-test4-dev \
  libqt-webkit4-dev \
  libqt-xml4-dev \
  sqlite-dev \
  libsqlite-dev \
"

# X11 Development libs.
RDEPENDS += "\
  libxi-dev \
  libxext-dev \
  libxdmcp-dev \
  libxau-dev \
  libx11 \
  libx11-dev \
  xproto \
  xproto-dev \
  xextproto-dev \
  libxrender \
"

# Misc libs.
RDEPENDS += " \
  kbproto-dev \
  tiff-dev \
  gtk+-dev \
  cairo-dev \
  pango-dev \
  lua5.1 \
  lua5.1-dev \
  lua5.1-static \
  libpng-dev \
"
