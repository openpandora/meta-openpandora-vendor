#!/bin/bash
TSLIB_CONSOLEDEVICE=none op_runfbapp ts_calibrate
zenity --info --title="Calibration" --text "The touchscreen has been calibrated. To activate the new values, you have to restart."