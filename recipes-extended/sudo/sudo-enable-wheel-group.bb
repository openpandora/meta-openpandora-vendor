LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PR = "r2"

RDEPENDS_${PN} = "sudo"

ALLOW_EMPTY_${PN} = "1"
PACKAGE_ARCH = "all"

# Edit sudoers to allow the use of the wheel group and non root users to mount/shutdown etc.
#Please consider this when using.
 
do_compile() {
        touch ${WORKDIR}/sudoers
        echo '%wheel ALL=(ALL) ALL' >> ${WORKDIR}/sudoers
        echo '%users ALL=/sbin/mount /cdrom,/sbin/umount /cdrom' >> ${WORKDIR}/sudoers
        echo '%users localhost=/sbin/shutdown -h now' >> ${WORKDIR}/sudoers
        echo '' >> ${WORKDIR}/sudoers
}

do_install() {
          install -d ${D}${sysconfdir}/sudoers.d/
          install -m 440 ${WORKDIR}/sudoers ${D}${sysconfdir}/sudoers.d/01_enablewheel
}
