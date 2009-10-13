# Validation image for Pandora handheld console
# for hardware testing and flashing images to NAND if copied to the SD in the correct places.

XSERVER ?= " \
    xserver-xorg \
    xf86-input-evdev \
    xf86-input-mouse \
    xf86-video-fbdev \
    xf86-input-keyboard \
"

inherit image

export IMAGE_BASENAME = "pandora-validation-image"

DEPENDS = "task-base"

IMAGE_INSTALL += " \
  task-pandora-core \
  task-pandora-validation \
"
 
IMAGE_PREPROCESS_COMMAND = "create_etc_timestamp"

# Helper to say what image we built, include GIT tag and image name.
PANDORA_VERSION_FILE = "${IMAGE_ROOTFS}/${sysconfdir}/op-version"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo Tag Name: `git tag|tail -n 1`> ${PANDORA_VERSION_FILE};cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo VERSION: `git-log -n1 --pretty=oneline|awk '{print $1}'` >> ${PANDORA_VERSION_FILE}; cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo Branch: ` git branch |awk '/*/{print $2}'` >> ${PANDORA_VERSION_FILE}; cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "echo Image Builder: '${LOGNAME}'@`cat /etc/hostname` >> ${PANDORA_VERSION_FILE};"
ROOTFS_POSTPROCESS_COMMAND += "echo Time Stamp: `date -R` >> ${PANDORA_VERSION_FILE};"
ROOTFS_POSTPROCESS_COMMAND += "echo Base Image Name: '${IMAGE_BASENAME}' >> ${PANDORA_VERSION_FILE};"
