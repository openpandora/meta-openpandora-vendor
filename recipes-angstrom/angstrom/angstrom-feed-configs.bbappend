# point everything to the pandora servers for now.

do_compile() {
        mkdir -p ${S}/${sysconfdir}/opkg

    echo "src/gz    all             http://next.openpandora.org/v2012.12/ipk/all" > ${S}/${sysconfdir}/opkg/openpandora-feed.conf
    echo "src/gz    armv7a          http://next.openpandora.org/v2012.12/ipk/armv7a-vfp-neon" >> ${S}/${sysconfdir}/opkg/openpandora-feed.conf
    echo "src/gz    openpandora     http://next.openpandora.org/v2012.12/ipk/openpandora" >> ${S}/${sysconfdir}/opkg/openpandora-feed.conf

}

FILES_${PN} = "${sysconfdir}/opkg/openpandora-feed.conf \
                                        "
CONFFILES_${PN} = "${sysconfdir}/opkg/openpandora-feed.conf \
					"
