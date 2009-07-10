DESCRIPTION = "Task file for default core/console apps in the Pandora image"

# Use this task as a base to ship all kernel modules and make sure firmware and drivers are installed for BT and WiFi.
# Please see metadata/openpandora.oe.git/packages/pandora-system/pandora-firmware/pandora-firmware/readme.txt for info on the hacks for firmware.

# Don't forget to bump the PR if you change it.

PR = "r0.2"

inherit task 

# Use the 'Powered by Angstrom' splashscreen for the Pandora default images.
# By doing this here we ensure that anyone building a standard Angstom image
# rather then one of these has all the Angstrom branding with no Pandora specifics.
PREFERRED_PROVIDER_virtual/psplash = "psplash-pandora"

RDEPENDS_${PN} = "\
        task-base-extended \
        task-proper-tools \
        pandora-firmware \
	wl1251-modules \
#        pandora-wifi pandora-wifi-tools \
        pandora-libpnd \
        omap3-deviceid \	
        omap3-sgx-modules devmem2 libgles-omap3 \
        sudo \
        lsof \
        libsdl-gfx \
        nfs-utils nfs-utils-client \
        tslib tslib-tests tslib-calibrate pointercal \
        bash \
        bzip2 \
        psplash \
        fbgrab fbset fbset-modes \
        portmap \
        fuse sshfs-fuse ntfs-3g \
        file \
        aufs aufs-tools \
        socat \
        strace \
        python-pygame \
        ksymoops \
        kexec-tools \
        minicom \
        nano \
        alsa-utils alsa-utils-alsactl alsa-utils-alsamixer alsa-utils-aplay \
        openssh-scp \
        openssh-ssh \
        bluez4 \
        wireless-tools \
        rdesktop \
        zip \
        networkmanager netm-cli \
        openssh-scp openssh-ssh \
        mplayer \
"

# Make sure we install all kernel modules with the Pandora images
RRECOMMENDS_${PN} += "kernel-modules"

PACKAGE_ARCH = "${MACHINE_ARCH}"
RRECOMMENDS_${PN}_append_armv7a = " omapfbplay"
