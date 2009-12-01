setenv bootargs debug root=/dev/mmcblk1p1 console=ttyS0,115200n8 rootdelay=2 rootfstype=ext3 ro vram=6272K omapfb.vram=0:1500K
fatload mmc 0 0x80300000 uImage; bootm 0x80300000
