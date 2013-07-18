PRINC := "${@int(PRINC) + 1}"

FILESEXTRAPATHS := "${THISDIR}/${PN}"

SRC_URI += "file://configure.patch"

do_configure() { 
  oe_runconf
}
