#!/bin/bash
TSLIB_CONSOLEDEVICE=none op_runfbapp ts_calibrate
sudo /usr/pandora/scripts/op_touchinit.sh
while ! zenity --question --title="Check Calibration" --text="Your new calibration setting has been applied.\n\nPlease check if the touchscreen is now working properly.\nIf not, you might want to try a recalibration.\n\n(Hint: use the nubs to press the button if the touchscreen is way off)" --ok-label="The touchscreen is fine" --cancel-label="Recalibrate"; do
      TSLIB_CONSOLEDEVICE=none op_runfbapp ts_calibrate
      sudo /usr/pandora/scripts/op_touchinit.sh  
done