
do_compile() {
        mkdir -p ${S}/${sysconfdir}/opkg

	echo "src/gz    all             http://next.openpandora.org/ipk/all" > ${S}/${sysconfdir}/opkg/pandora-feed.conf
    echo "src/gz    armv7a          http://next.openpandora.org/ipk/armv7a" >> ${S}/${sysconfdir}/opkg/pandora-feed.conf
    echo "src/gz    omap3_pandora   http://next.openpandora.org/ipk/omap3_pandora" >> ${S}/${sysconfdir}/opkg/pandora-feed.conf

}

FILES_${PN} = "${sysconfdir}/opkg/pandora-feed.conf \
                                        "

CONFFILES_${PN} = "${sysconfdir}/opkg/pandora-feed.conf \
					"
