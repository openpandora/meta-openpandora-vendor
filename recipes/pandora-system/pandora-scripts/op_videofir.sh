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
	file="${1}_${2}"
	if [ -f "$file" ]; then
		# hardcode overlay for now.. We'll update this as needed
		echo "writing fir: $2"
		cat "$file" > "/sys/devices/platform/omapdss/overlay1/filter_coef_$2"
	fi
}

apply_filter "${base_path}" up_h
apply_filter "${base_path}" up_v3
apply_filter "${base_path}" up_v5
