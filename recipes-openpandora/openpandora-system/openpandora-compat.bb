DESCRIPTION = "Backward compatibility with old pandora firmware hacks"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=956931f56ef227f7d172a149ddb40b48"
COMPATIBLE_MACHINE = "openpandora"

PR = "r1"

SRC_URI = " \
          file://LICENSE \
	  file://libbz2.so.1.0.5 \
          file://libcrypto.so.0.9.8 \
          file://libcurl.so.4.2.0 \ 
          file://libffi.so.5.0.9 \
          file://libjpeg.so.62.0.0 \
          file://libssl.so.0.9.8 \	  
"

do_install() {
          install -d ${D}${libdir}/
          
          install -m 0644 ${WORKDIR}/libbz2.so.1.0.5  ${D}${libdir}/libbz2.so.1.0.5
          ln -s libbz2.so.1.0.5 ${D}${libdir}/libbz2.so.1
          ln -s libbz2.so.1.0.5 ${D}${libdir}/libbz2.so.1.0
          
          install -m 0644 ${WORKDIR}/libcrypto.so.0.9.8  ${D}${libdir}/libcrypto.so.0.9.8
          
          install -m 0644 ${WORKDIR}/libcurl.so.4.2.0  ${D}${libdir}/libcurl.so.4.2.0
          ln -s libcurl.so.4.2.0 ${D}${libdir}/libcurl.so.4
          
          install -m 0644 ${WORKDIR}/libffi.so.5.0.9  ${D}${libdir}/libffi.so.5.0.9
          ln -s libffi.so.5.0.9 ${D}${libdir}/libffi.so.5
          
          install -m 0644 ${WORKDIR}/libjpeg.so.62.0.0  ${D}${libdir}/libjpeg.so.62.0.0
          ln -s libjpeg.so.62.0.0 ${D}${libdir}/libjpeg.so.62
          
          install -m 0644 ${WORKDIR}/libssl.so.0.9.8  ${D}${libdir}/libssl.so.0.9.8                
}


PACKAGE_ARCH = "${MACHINE_ARCH}"
