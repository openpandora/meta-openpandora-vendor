#!/bin/bash
#actions done when the lid is closed
#only argument is 0 for open 1 for closed
#may also be called after inactivity, like X DPMS

/usr/pandora/scripts/op_power.sh $1 lid
