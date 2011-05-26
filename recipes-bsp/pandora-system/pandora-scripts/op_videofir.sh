#!/bin/sh

set -e

if [ $# -ne 1 ]; then
	echo "usage: $0 <fir_file_basename>"
	exit 1
fi

if [ "$1" = `basename "$1"` ]; then
	base_path="/etc/pandora/conf/dss_fir/$1"
else
	base_path="$1"
fi

apply_filter()
{
	file="${1}"
	if [ ! -f "$file" ]; then
	    file="${1}_up"
	fi
	if [ -f "$file" ]; then
		# hardcode overlay for now.. We'll update this as needed
		echo "writing fir:"
		head -n1 "$file"
		sed -n 3,10p "$file" > "/sys/devices/platform/omapdss/overlay1/filter_coef_up_h"
		sed -n 12,19p "$file" > "/sys/devices/platform/omapdss/overlay1/filter_coef_up_v3"
		sed -n 21,28p "$file" > "/sys/devices/platform/omapdss/overlay1/filter_coef_up_v5"
	else
	    echo "No filter with that name"
	fi
}

apply_filter "${base_path}"