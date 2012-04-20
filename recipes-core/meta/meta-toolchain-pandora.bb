# OpenPandora Sample toolchain/SDK scripts.

PR = "r5"
#TOOLCHAIN_HOST_TASK = "task-pandora-toolchain-host"
#TOOLCHAIN_TARGET_TASK = "task-pandora-toolchain-target"
TOOLCHAIN_OUTPUTNAME = "${SDK_NAME}-toolchain-pandora-${DISTRO_VERSION}"

PANDORA_FEEDS = "http://next.openpandora.org/ipk"


require recipes-core/meta/meta-toolchain.bb

toolchain_create_sdk_env_script_append() {
        echo 'alias opkg-target="opkg-cl -f ${OECORE_TARGET_SYSROOT}/etc/opkg.conf -o ${OECORE_TARGET_SYSROOT}"' >> $script
        echo 'alias opkg-sdk="opkg-cl -f ${OECORE_NATIVE_SYSROOT}/etc/opkg-sdk.conf -o ${OECORE_NATIVE_SYSROOT}" ' >> $script
        
        rm ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        rm ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf
        rm ${SDK_OUTPUT}/${SDKPATHNATIVE}/etc/opkg-sdk.conf
   
        echo "arch all 1" >>  ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        echo "arch any 6" >>  ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        echo "arch noarch 11" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        echo "arch armv7a 51" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        echo "arch omap3_pandora 66" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        echo "src oe ${PANDORA_FEEDS}" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        echo "src oe-all ${PANDORA_FEEDS}/all" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        echo "src oe-armv7a ${PANDORA_FEEDS}/armv7a" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf
        echo "src oe-omap3_pandora ${PANDORA_FEEDS}/omap3_pandora" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg.conf

        echo "arch all 1" >>  ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf
        echo "arch any 6" >>  ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf
        echo "arch noarch 11" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf
        echo "arch x86_64-nativesdk 16" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf
        echo "src oe ${PANDORA_FEEDS}" >>  ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf
        echo "src oe-all ${PANDORA_FEEDS}/all" >>  ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf
        echo "src oe-x86_64-nativesdk ${PANDORA_FEEDS}/x86_64-nativesdk" >> ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf

        cp ${SDK_OUTPUT}/${SDKTARGETSYSROOT}/etc/opkg-sdk.conf  ${SDK_OUTPUT}/${SDKPATHNATIVE}/etc/opkg-sdk.conf

}

