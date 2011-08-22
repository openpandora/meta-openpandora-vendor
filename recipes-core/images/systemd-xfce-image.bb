require systemd-image.bb

IMAGE_INSTALL += " \
	task-xfce-base \
	task-xserver \
"

export IMAGE_BASENAME = "systemd-xfce-image"

