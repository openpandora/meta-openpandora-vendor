DESCRIPTION = "SLiM Themes for the OpenPandora"
SECTION = "x11/dm"
LICENSE = "GPL"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

DEPENDS = "slim"
RDEPENDS = "slim"

PR = "r4"

SRC_URI = " \        
"

# Greek theme.

SRC_URI_append = " \
           file://LICENSE \
           file://greek/background.png \
           file://greek/panel.png \
           file://greek/slim.theme \
           file://pnd-default/background.png \
           file://pnd-default/panel.png \
           file://pnd-default/slim.theme \
"

do_install() {         
          install -d ${D}${datadir}/slim/themes/
          
          install -d ${D}${datadir}/slim/themes/greek/          
          install -m 0644 ${WORKDIR}/greek/* ${D}${datadir}/slim/themes/greek/
          install -d ${D}${datadir}/slim/themes/pnd-default/          
          install -m 0644 ${WORKDIR}/pnd-default/* ${D}${datadir}/slim/themes/pnd-default/
}

pkg_postinst() {
#!/bin/sh
sed -i -e 's/  default/  pnd-default/' /etc/slim.conf
}
		
FILES_${PN} += "${prefix} ${sysconfdir}"
