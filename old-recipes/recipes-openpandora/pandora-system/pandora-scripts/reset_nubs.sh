#!/bin/bash
echo 1 > /sys/bus/i2c/drivers/vsense/3-0066/reset
sleep 1
echo 0 > /sys/bus/i2c/drivers/vsense/3-0066/reset
