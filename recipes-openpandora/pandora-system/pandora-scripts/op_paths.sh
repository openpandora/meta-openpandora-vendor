
# files changing between kernel versions

if [ -e /sys/class/backlight/pandora-backlight ]; then
	SYSFS_BACKLIGHT=/sys/class/backlight/pandora-backlight
elif [ -e /sys/class/backlight/twl4030-pwm0-bl ]; then
	SYSFS_BACKLIGHT=/sys/class/backlight/twl4030-pwm0-bl
else
	echo "ERROR: backlight control not found" >&2
	SYSFS_BACKLIGHT=/dev/null
fi
SYSFS_BACKLIGHT_BRIGHTNESS=${SYSFS_BACKLIGHT}/brightness

if [ -e /sys/devices/omapdss/display0/gamma ]; then
	SYSFS_GAMMA=/sys/devices/omapdss/display0/gamma
elif [ -e /sys/devices/platform/omap2_mcspi.1/spi1.1/gamma ]; then
	SYSFS_GAMMA=/sys/devices/platform/omap2_mcspi.1/spi1.1/gamma
else
	echo "ERROR: gamma control not found" >&2
	SYSFS_GAMMA=/dev/null
fi
