require systemd-image.bb

IMAGE_INSTALL += " \
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
    libpam libpam-xtests\
    slim \
    coreutils \
    util-linux \
    pandora-libpnd \
    pandora-slim-themes \
    pandora-scripts \
    pandora-misc \
    file \
"

export IMAGE_BASENAME = "systemd-pndwip-image"
