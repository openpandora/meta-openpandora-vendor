#!/bin/bash
POSMENU=`DISPLAY=:0.0 xwininfo -name xfce4-menu-plugin | egrep 'Absolute upper-left X|Absolute upper-left Y' | awk '{print $4}'`
Xold=`DISPLAY=:0.0 xdotool getmouselocation | awk  '{print $1}' | sed 's/^..//'`
Yold=`DISPLAY=:0.0 xdotool getmouselocation | awk  '{print $2}' | sed 's/^..//'`
Xnew=`echo $POSMENU|awk '{print $1}'`
Ynew=`echo $POSMENU|awk '{print $2}'`
DISPLAY=:0.0 xdotool mousemove $Xnew $Ynew
DISPLAY=:0.0 xdotool click 1
DISPLAY=:0.0 xdotool mousemove $Xold $Yold
