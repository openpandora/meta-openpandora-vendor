DESCRIPTION = "OpenPandora: Basic SDK development packages"

PR = "r1"
ALLOW_EMPTY = "1"

DEPENDS = "task-pandora-sdk-bare"

RDEPENDS = "\
    task-pandora-sdk-bare \
    alsa-dev \
    audiofile-dev \
    bluez-libs-dev \
    dbus-dev \
    expat-dev \
    fontconfig-dev \
    freetype-dev \
    glib-2.0-dev \
    gstreamer-dev \
    libice-dev \
    ipkg-dev \
    jpeg-dev \
    libapm-dev \
    alsa-lib-dev \
    libdisplaymigration-dev \
    libetpan-dev \
    libgcrypt-dev \
    libglade-dev \
    gnutls-dev \
    libgpg-error-dev \
    libidl-dev \
    libiw-dev \
    libmimedir-dev \
    libpcap-dev \
    pixman-dev \
    libpng-dev \
    libschedule-dev \
    libsm-dev \
    libsoundgen-dev \
    libsoup-dev \
    libsvg-dev \
    libtododb-dev \
    libxml2-dev \
    ncurses-dev \
    openobex-dev \
    popt-dev \
    readline-dev \
    libsqlite-dev \
    zlib-dev \
    libxmu-dev \
    libts-dev \
"
