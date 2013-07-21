require systemd-image.bb

PR = "r2"

IMAGE_INSTALL += " \
    openpandora-u-boot-autoboot-sd \
    task-base \
    task-pandora-base \
    task-xfce-base \
    task-xserver \
    nano \
    hsetroot \
    zenity \
    xset \
    xmodmap \
    libvorbis \
    libsdl-mixer \
    libsdl-net \
    libmikmod \
    libpam libpam-xtests  pam-plugin-mkhomedir\
    slim \
    coreutils \
    util-linux \
    pandora-libpnd \
    pandora-slim-themes \
    pandora-scripts \
    pandora-misc \
    file \
    fbgrab \
    udev-extra-rules \
"

export IMAGE_BASENAME = "systemd-pndwip-image"
