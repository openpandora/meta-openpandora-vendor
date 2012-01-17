# XFCE image for the Pandora handheld console

IMAGE_LINGUAS = "de-de fr-fr en-gb en-us es-es"

IMAGE_DEV_MANAGER   = "udev"
IMAGE_INIT_MANAGER  = "systemd"
IMAGE_INITSCRIPTS   = " "
IMAGE_LOGIN_MANAGER = "tinylogin shadow"

inherit image

PR = "r4"

export IMAGE_BASENAME = "openpandora-xfce-image"

SPLASH = "psplash-openpandora"

DEPENDS = "task-base"

IMAGE_INSTALL += " \
    angstrom-task-boot \
    task-basic \
    task-core-openpandora \
    task-xfce-openpandora \
    ${SPLASH} \	
"

IMAGE_PREPROCESS_COMMAND = "rootfs_update_timestamp"

# Helper to say what image we built, include GIT tag and image name.
OPENPANDORA_VERSION_FILE = "${IMAGE_ROOTFS}/${sysconfdir}/op-version"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo Tag Name: `git tag|tail -n 1`> ${OPENPANDORA_VERSION_FILE};cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo VERSION: `git-log -n1 --pretty=oneline|awk '{print $1}'` >> ${OPENPANDORA_VERSION_FILE}; cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo Branch: ` git branch |awk '/*/{print $2}'` >> ${OPENPANDORA_VERSION_FILE}; cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "echo Image Builder: '${LOGNAME}'@`cat /etc/hostname` >> ${OPENPANDORA_VERSION_FILE};"
ROOTFS_POSTPROCESS_COMMAND += "echo Time Stamp: `date -R` >> ${OPENPANDORA_VERSION_FILE};"
ROOTFS_POSTPROCESS_COMMAND += "echo Base Image Name: '${IMAGE_BASENAME}' >> ${OPENPANDORA_VERSION_FILE};"
