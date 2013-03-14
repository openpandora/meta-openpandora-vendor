#!/bin/sh

if [ ! -e /proc/pandora/sys_mhz_max ]; then
  echo "error: no support in kernel"
  exit 1
fi
if [ $# -ne 1 ]; then
  echo "usage:"
  echo "$0 <sys_clock>"
  exit 1
fi

sync

# TODO: we need to stop all RAM users here, that includes DMAs and DSP
# only handling the display for now..
echo 1 > /sys/class/graphics/fb0/blank
echo $1 > /proc/pandora/sys_mhz_max
echo 0 > /sys/class/graphics/fb0/blank
