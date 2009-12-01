setenv bootargs debug console=ttyS2,115200n8 ramdisk_size=8192 root=/dev/ram0 rw rootfstype=ext2 initrd=0x81600000,8M vram=6272K omapfb.vram=0:1500K
fatload mmc 0 0x80300000 uImage; fatload mmc 0 0x81600000 rd-ext2.bin; bootm 0x80300000
# setenv bootargs debug root=/dev/mmcblk0p2 console=ttyS0,115200n8 rootdelay=2 rootfstype=ext3 ro vram=6272K omapfb.vram=0:1500K
# fatload mmc 0 0x80300000 uImage; bootm 0x80300000
# omapfb.debug=y omapdss.debug=y
