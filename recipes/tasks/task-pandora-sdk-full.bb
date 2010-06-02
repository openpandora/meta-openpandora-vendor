DESCRIPTION = "OpenPandora: Full SDK development packages"

PR = "r1"
ALLOW_EMPTY = "1"

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
