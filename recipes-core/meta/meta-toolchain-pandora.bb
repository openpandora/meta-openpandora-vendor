# OpenPandora Sample toolchain/SDK scripts.

PR = "r4"
TOOLCHAIN_HOST_TASK = "task-pandora-toolchain-host"
TOOLCHAIN_TARGET_TASK = "task-pandora-toolchain-target"

require meta-toolchain.bb

SDK_SUFFIX = "toolchain-openpandora"

PANDORA_VERSION_FILE = "${SDK_OUTPUT}/${SDKPATH}/op-toolchain-version"

QT_DIR_NAME = "qt4"

do_populate_sdk_append() {

       # SED out incorrect paths in SDK support *-config files so tools can use the files to find libs to cross compile.
       # not ready to commit.

       # Tweak the environment-setup script to try get Qt4 X11 dev working.
       # Based on Koen's mods to create the Qte SDK.
       
       script = "${SDK_OUTPUT}/${SDKPATH}/environment-setup"
       touch $script
       echo 'export OE_QMAKE_CC=${TARGET_SYS}-gcc' >> $script
       echo 'export OE_QMAKE_CXX=${TARGET_SYS}-g++' >> $script
       echo 'export OE_QMAKE_LINK=${TARGET_SYS}-g++' >> $script
       echo 'export OE_QMAKE_LIBDIR_QT=${SDKPATH}/${TARGET_SYS}/${libdir}' >> $script
       echo 'export OE_QMAKE_INCDIR_QT=${SDKPATH}/${TARGET_SYS}/${includedir}/${QT_DIR_NAME}' >> $script
       echo 'export OE_QMAKE_MOC=${SDKPATH}/bin/moc4' >> $script
       echo 'export OE_QMAKE_UIC=${SDKPATH}/bin/uic4' >> $script
       echo 'export OE_QMAKE_UIC3=${SDKPATH}/bin/uic34' >> $script
       echo 'export OE_QMAKE_RCC=${SDKPATH}/bin/rcc4' >> $script
       echo 'export OE_QMAKE_QDBUSCPP2XML=${SDKPATH}/bin/qdbuscpp2xml4' >> $script
       echo 'export OE_QMAKE_QDBUSXML2CPP=${SDKPATH}/bin/qdbusxml2cpp4' >> $script
       echo 'export OE_QMAKE_QT_CONFIG=${SDKPATH}/${TARGET_SYS}/${datadir}/${QT_DIR_NAME}/mkspecs/qconfig.pri' >> $script
       echo 'export QMAKESPEC=${SDKPATH}/${TARGET_SYS}/${datadir}/${QT_DIR_NAME}/mkspecs/linux-g++' >> $script


       # Helper to say what toolchain we built, include GIT tag etc.

       OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo Tag Name: `git tag|tail -n 1`> ${PANDORA_VERSION_FILE};cd $OLD_PWD;
       OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo VERSION: `git-log -n1 --pretty=oneline|awk '{print $1}'` >> ${PANDORA_VERSION_FILE}; cd $OLD_PWD;
       OLD_PWD=$PWD; cd `dirname '${FILE_DIRNAME}'`; echo Branch: ` git branch |awk '/*/{print $2}'` >> ${PANDORA_VERSION_FILE}; cd $OLD_PWD;
       echo Toolchain Builder: '${LOGNAME}'@`cat /etc/hostname` >> ${PANDORA_VERSION_FILE};
       echo Time Stamp: `date -R` >> ${PANDORA_VERSION_FILE};
       echo Toolchain Name: '${TOOLCHAIN_OUTPUTNAME}' >> ${PANDORA_VERSION_FILE};

       # Repack SDK after 'munging'
       cd ${SDK_OUTPUT}
       fakeroot tar cfj ${SDK_DEPLOY}/${TOOLCHAIN_OUTPUTNAME}.tar.bz2 .
}
