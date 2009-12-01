# Console image for the Pandora handheld console

IMAGE_LINGUAS = "de-de fr-fr en-gb en-us es-es tr-tr"

IMAGE_LOGIN_MANAGER = "shadow"

inherit image

export IMAGE_BASENAME = "pandora-core-image"

SPLASH = "psplash-omap3pandora"

DEPENDS = "task-base"

IMAGE_INSTALL += " \
    task-pandora-core \
    ${SPLASH} \	
"

IMAGE_PREPROCESS_COMMAND = "create_etc_timestamp"

#Dont use on core images as you have no GUI to let you set a root password ;).
#zap root password for release images
#ROOTFS_POSTPROCESS_COMMAND += '${@base_conditional("DISTRO_TYPE", "release", "zap_root_password; ", "",d)}'

# Helper to say what image we built, include GIT tag and image name.
PANDORA_VERSION_FILE = "${IMAGE_ROOTFS}/${sysconfdir}/op-version"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo Tag Name: `git tag|tail -n 1`> ${PANDORA_VERSION_FILE};cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo VERSION: `git-log -n1 --pretty=oneline|awk '{print $1}'` >> ${PANDORA_VERSION_FILE}; cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo Branch: ` git branch |awk '/*/{print $2}'` >> ${PANDORA_VERSION_FILE}; cd $OLD_PWD;"
ROOTFS_POSTPROCESS_COMMAND += "echo Image Builder: '${LOGNAME}'@`cat /etc/hostname` >> ${PANDORA_VERSION_FILE};"
ROOTFS_POSTPROCESS_COMMAND += "echo Time Stamp: `date -R` >> ${PANDORA_VERSION_FILE};"
ROOTFS_POSTPROCESS_COMMAND += "echo Base Image Name: '${IMAGE_BASENAME}' >> ${PANDORA_VERSION_FILE};"
