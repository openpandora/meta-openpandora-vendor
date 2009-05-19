DESCRIPTION = "Task file for default core/console apps in the Pandora image"

# Use this task as a base to ship all kernel modules and make sure firmware and drivers are installed for BT and WiFi.
# Please see metadata/openpandora.oe.git/packages/pandora-system/pandora-firmware/pandora-firmware/readme.txt for info on the hacks for firmware.

# Don't forget to bump the PR if you change it.

PR = "r3.3"

inherit task 

RDEPENDS_${PN} = "\
        task-base-extended \
        task-proper-tools \
        pandora-firmware \
        pandora-wifi pandora-wifi-tools \
        pandora-libpnd \
        omap3-deviceid \	
        omap3-sgx-modules devmem2 libgles-omap3 \
        sudo \
        lsof \
        gnome-volume-manager \
        libwiimote \
        libsdl-gfx \
        nfs-utils nfs-utils-client \
        i2c-tools \
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
        bluez4 bluez-hcidump bluez-utils \
        wireless-tools \
        rdesktop \
        zip \
        openssh-scp openssh-ssh \
        mplayer \
        networkmanager netm-cli \
"

# Make sure we install all kernel modules with the Pandora images
RRECOMMENDS_${PN} += "kernel-modules"

PACKAGE_ARCH = "${MACHINE_ARCH}"
RRECOMMENDS_${PN}_append_armv7a = " omapfbplay"
