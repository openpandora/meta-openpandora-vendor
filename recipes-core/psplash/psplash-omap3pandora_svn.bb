require psplash.inc
require psplash-ua.inc

PR = "${INC_PR}.7"

ALTERNATIVE_PRIORITY = "30"
ALTERNATIVE_PRIORITY_omap3pandora = "5"

# You can create your own pslash-hand-img.h by doing
# ./make-image-header.sh <file>.png POKY
# and rename the resulting .h to pslash-hand-img.h (for the logo)
# respectively psplash-bar-img.h (BAR) for the bar.

SRCREV = "422"

SRC_URI = "svn://svn.o-hand.com/repos/misc/trunk;module=psplash;proto=http \
          file://configurability.patch;patch=1 \
          file://psplash-poky-img.h \
          file://psplash-bar-img.h \
          file://psplash-default \
          file://splashfuncs \
          file://psplash-init \
"
          
S = "${WORKDIR}/psplash"
