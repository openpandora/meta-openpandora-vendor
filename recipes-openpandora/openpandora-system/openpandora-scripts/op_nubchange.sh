#!/bin/sh

if [ $# -ne 2 ]; then
  echo "usage:"
  echo "$0 <left_nub_mode> <right_nub_mode>"
  exit 1
fi

nub0_ev=`grep -A8 nub0 /proc/bus/input/devices | grep '^H: ' | awk '{print $3}'`
nub1_ev=`grep -A8 nub1 /proc/bus/input/devices | grep '^H: ' | awk '{print $3}'`

echo $1 > /proc/pandora/nub0/mode
echo $2 > /proc/pandora/nub1/mode

for i in `seq 20`; do
  if test -c /dev/input/$nub0_ev && test -c /dev/input/$nub1_ev; then
    break;
  fi
  sleep .1
done
