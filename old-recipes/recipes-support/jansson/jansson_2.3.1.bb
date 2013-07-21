DESCRIPTION = "C library for encoding, decoding and manipulating JSON data"
SECTION = "libs"

SRC_URI = "http://www.digip.org/jansson/releases/jansson-${PV}.tar.bz2"

SRC_URI[md5sum] = "fb529b7d96162950f2123dca8704c4c6"
SRC_URI[sha256sum] = "a8904c913662e6a0d84d4aa00e6dc7ead916d68ea1708ec330e0eace7e44a8dc"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=6946b728e700de875e60ebb453cc3a20"

PR = "r1"

inherit autotools

