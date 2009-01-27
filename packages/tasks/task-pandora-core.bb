DESCRIPTION = "Task file for default core/console apps in the Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r12"

inherit task 

RDEPENDS_${PN} = "\
	task-base-extended \
	task-proper-tools \
	pandora-wifi \
	pandora-firmware \
	libgles-omap3 \
	libwiimote \
	nfs-utils \
	nfs-utils-client \
#	unionfs-modules \
	unionfs-utils \
	tslib \
	tslib-tests \
	tslib-calibrate \
	pointercal \
	bash \
	bzip2 \
	psplash \
	mkfs-jffs2 \
	fbgrab \
	fbset \
	portmap \
	fbset-modes \
	fuse \
	socat \
	strace \
	python-pygame \
	ksymoops \
	kexec-tools \
	minicom \
	nano \
#	mono \
	alsa-utils \
	alsa-utils-alsactl \
	alsa-utils-alsamixer \
	alsa-utils-aplay \
	openssh-scp \
	openssh-ssh \
	bluez-hcidump \
	bluez-utils \
	wireless-tools \
	rdesktop \
	zip \
	openssh-scp openssh-ssh \
#	networkmanager \
"
