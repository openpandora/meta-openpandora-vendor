#!/bin/sh

. /usr/pandora/scripts/op_paths.sh

if [ ! -e "$SYSFS_DSS_GAMMA" ]; then
  echo "Control file is missing, might be incompatible kernel"
  exit 1
fi

gamma="$@"

if [ "$gamma" = "0" ]; then
  # set user default gamma
  gamma="1"
  if [ -f /etc/pandora/conf/dssgamma.state ]; then
    dssgamma=$(cat /etc/pandora/conf/dssgamma.state)
    dssgamma=$(echo "scale=2;$dssgamma / 100" | bc)
    if [ -n "$dssgamma" ]; then
      gamma=$dssgamma
    fi
  fi
fi

if [ "$gamma" = "1" -o "$gamma" = "1.00" ]; then
  # no gamma adjustment
  echo 0 > $SYSFS_DSS_GAMMA
  exit 0
fi

if [ "`which op_gammatable`" = "" ]; then
  echo "op_gammatable tool required"
  exit 1
fi

# just forward args to op_gammatable
op_gammatable $gamma > $SYSFS_DSS_GAMMA
