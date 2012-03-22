DESCRIPTION = "Task file for validation apps and scripts in the Pandora image"

# Don't forget to bump the PR if you change it.

PR = "r1"
LICENSE = "MIT"

inherit task 

RDEPENDS_${PN} = "\
"

PACKAGE_ARCH = "${MACHINE_ARCH}"
