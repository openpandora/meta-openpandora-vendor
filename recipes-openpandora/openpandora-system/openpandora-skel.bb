DESCRIPTION = "Default 'new user' files on the OpenPandora."

COMPATIBLE_MACHINE = "openpandora"

# /etc/skel is used by Shadow's useradd so you really have that installed for this to make sense ;)
RDEPENDS_${PN} = "shadow"

PR = "r22"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=956931f56ef227f7d172a149ddb40b48"

SRC_URI = " \
  file://LICENSE \
  file://.xinitrc \     
  file://bashrc \
  file://profile \
  file://mplayconfig \
  file://pam_environment \
  file://xsettings.xml \
  file://pndXmodmap \
  file://asoundrc \
  file://vimrc \
  file://fuse \
  file://snd-pcm-oss \
  file://PandoraQuickStart.pdf \
  file://PandoraQuickStart.desktop \
  file://gtkrc-2.0 \
"
#  file://op_btenabled \
#

# xsettings.xml is a hack until I can figure out why XDG configs are not setting the icon theme for Xfce/GTK+

do_install() {
  install -d ${D}${sysconfdir}/skel/
  install -d ${D}${sysconfdir}/skel/Desktop
  install -d ${D}${sysconfdir}/modutils/
  install -d ${D}${sysconfdir}/pandora/
  install -m 0644 ${WORKDIR}/.xinitrc ${D}${sysconfdir}/skel/.xinitrc
  install -m 0644 ${WORKDIR}/vimrc ${D}${sysconfdir}/skel/.vimrc
  install -m 0644 ${WORKDIR}/bashrc ${D}${sysconfdir}/skel/.bashrc
  install -m 0644 ${WORKDIR}/profile ${D}${sysconfdir}/skel/.profile
  install -m 0644 ${WORKDIR}/pam_environment ${D}${sysconfdir}/skel/.pam_environment
  install -m 0644 ${WORKDIR}/pndXmodmap ${D}${sysconfdir}/skel/.pndXmodmap
  install -m 0644 ${WORKDIR}/asoundrc ${D}${sysconfdir}/skel/.asoundrc
  install -m 0644 ${WORKDIR}/gtkrc-2.0 ${D}${sysconfdir}/skel/.gtkrc-2.0
  install -m 0644 ${WORKDIR}/fuse ${D}${sysconfdir}/modutils/fuse
  install -m 0644 ${WORKDIR}/snd-pcm-oss ${D}${sysconfdir}/modutils/snd-pcm-oss
  install -m 0755 ${WORKDIR}/PandoraQuickStart.desktop ${D}${sysconfdir}/skel/Desktop/PandoraQuickStart.desktop
  install -m 0755 ${WORKDIR}/PandoraQuickStart.pdf ${D}${sysconfdir}/pandora/PandoraQuickStart.pdf
  
  install -d ${D}${sysconfdir}/skel/Applications/Settings/xfce4/xfconf/xfce-perchannel-xml
  install -m 0644 ${WORKDIR}/xsettings.xml ${D}${sysconfdir}/skel/Applications/Settings/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
  
  install -d ${D}${sysconfdir}/skel/.mplayer/
  install -m 0644 ${WORKDIR}/mplayconfig ${D}${sysconfdir}/skel/.mplayer/config
}

#  install -m 0644 ${WORKDIR}/op_btenabled ${D}${sysconfdir}/skel/.op_btenabled

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES_${PN} = "/*"
