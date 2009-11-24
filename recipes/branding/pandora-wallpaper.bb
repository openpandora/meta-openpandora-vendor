DESCRIPTION = "Some nice wallpapers created by the community for the OpenPandora, thanks go to the community for the graphics"

PR = "r0"

SRC_URI = " \
          file://Pandora-3DLogo.png \
          file://Pandora-Asteroids.jpg \
          file://Pandora-BlackAndBrown.png \
          file://Pandora-BlackAndBrownSmall.png \
          file://Pandora-BlackAndWhite1.png \
          file://Pandora-BlackAndWhite2.png \
          file://Pandora-BlackOnWhite.png \
          file://Pandora-BlackOnWhiteSmall.png \
          file://Pandora-BlueGlow.jpg \
          file://Pandora-Blue.png \
          file://Pandora-Brick.png \
          file://Pandora-ColorsOnBlack.png \
          file://Pandora-CrystalBlue.jpg \
          file://Pandora-Cubes.png \
          file://Pandora-DarkCubes.png \
          file://Pandora-FireAndIce.png \
          file://Pandora-FireCube.png \
          file://Pandora-FireCubeSmall.png \
          file://Pandora-Galaxy-Blue.jpg \
          file://Pandora-Galaxy-Green.jpg \
          file://Pandora-Galaxy.jpg \
          file://Pandora-Galaxy-Red.jpg \
          file://Pandora-Green.jpg \
          file://Pandora-Grid.png \
          file://Pandora-Hockey.jpg \
          file://Pandora-Lines.jpg \
          file://Pandora-Patchwork.jpg \
          file://Pandora-Red.jpg \
          file://Pandora-Rust.png \
          file://Pandora-Simple2.png \
          file://Pandora-Simple2Small.png \
          file://Pandora-Simple.png \
          file://Pandora-SimpleRed.png \
          file://Pandora-SimpleSmall.png \
          file://Pandora-TwoMonths.png \
          file://Pandora-WhiteBevel.png \
          file://Pandora-WhiteBevelSmall.png \
          file://Pandora-WhiteOnBlack.png \
          file://Pandora-WhiteOnBlackSmall.png \
          file://Pandora-WoodenLogo.jpg \  
"

do_install() {         
          install -d ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-3DLogo.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Asteroids.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-BlackAndBrown.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-BlackAndBrownSmall.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-BlackAndWhite1.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-BlackAndWhite2.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-BlackOnWhite.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-BlackOnWhiteSmall.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-BlueGlow.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Blue.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Brick.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-ColorsOnBlack.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-CrystalBlue.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Cubes.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-DarkCubes.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-FireAndIce.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-FireCube.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-FireCubeSmall.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Galaxy-Blue.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Galaxy-Green.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Galaxy.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Galaxy-Red.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Green.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Grid.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Hockey.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Lines.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Patchwork.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Red.jpg ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Rust.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Simple2.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Simple2Small.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-Simple.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-SimpleRed.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-SimpleSmall.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-TwoMonths.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-WhiteBevel.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-WhiteBevelSmall.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-WhiteOnBlack.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-WhiteOnBlackSmall.png ${D}${prefix}/xfce4/backdrops/
          install -m 0644 ${WORKDIR}/Pandora-WoodenLogo.jpg ${D}${prefix}/xfce4/backdrops/  
}

PACKAGE_ARCH = "all"
FILES_${PN} += "${prefix}"
