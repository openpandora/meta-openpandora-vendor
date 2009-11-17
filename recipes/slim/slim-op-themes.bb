DESCRIPTION = "SLiM Themes for the OpenPandora"
SECTION = "x11/dm"
LICENSE = "GPL"

DEPENDS = ""
RDEPENDS += "slim"

PR = "r0"

SRC_URI = " \        
"

# Greek theme.

SRC_URI_append = " \
           file://greek/background.png \
           file://greek/panel.png \
           file://greek/slim.theme \
"

do_install() {         
          install -d ${D}${datadir}/slim/themes/
          
          install -d ${D}${datadir}/slim/themes/greek/          
          install -m 0644 ${WORKDIR}/greek/* ${D}${datadir}/slim/themes/greek/
}

pkg_postinst() {
#!/bin/sh
sed -i -e 's/  default/  greek/' ${D}${sysconfdir}/slim.conf
}
		
FILES_${PN} += "${prefix} ${sysconfdir}"
