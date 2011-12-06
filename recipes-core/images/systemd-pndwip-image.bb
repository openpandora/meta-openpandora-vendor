require systemd-image.bb

IMAGE_INSTALL += " \
	task-xfce-base \
	task-xserver \
    sudo \
    nano \
    kernel-modules \
    wireless-tools \
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
    pandora-firmware \
    pandora-libpnd \
    pandora-first-run-wizard \
    pandora-wallpaper-official \
    pandora-slim-themes \
    pandora-scripts lsof \
    pandora-skel \
    pandora-misc \
    pandora-sudoers \ 
    pandora-state \
"

export IMAGE_BASENAME = "systemd-pndwip-image"

