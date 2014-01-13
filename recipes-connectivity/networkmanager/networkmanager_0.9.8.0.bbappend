PRINC := "${@int(PRINC) + 1}"

PACKAGE_ARCH = "${MACHINE_ARCH}"
EXTRA_OECONF += " --without-ck "
