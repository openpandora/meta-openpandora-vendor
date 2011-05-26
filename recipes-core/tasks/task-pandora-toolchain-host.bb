require task-sdk-host.bb

DESCRIPTION = "Host packages for OpenPandora SDK"
LICENSE = "MIT"
ALLOW_EMPTY = "1"

PR = "r1"

# Include this to get the native to target Qt4 tools.
RDEPENDS_${PN} += "qt4-tools-sdk"
