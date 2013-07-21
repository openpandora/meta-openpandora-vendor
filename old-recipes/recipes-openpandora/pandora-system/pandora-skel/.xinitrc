# This script sets up a few XDG vairables for the OpenPandora (to find the Xfce defaults etc.)
# and then launches the chosen user session (mainly Xfce or PMenu)

# The makes sure that /etc/xdg/op is added to the vairables to get the defaults for the OP.
if test "x$XDG_CONFIG_DIRS" = "x"
then
  XDG_CONFIG_DIRS="/etc/xdg/op:/etc/xdg"
else
  XDG_CONFIG_DIRS="/etc/xdg/op:$XDG_CONFIG_DIRS:/etc/xdg"
fi
export XDG_CONFIG_DIRS

if test "x$XDG_DATA_DIRS" = "x"
then
  XDG_DATA_DIRS="/usr/local/share:/usr/share:@_datadir_@"
  XDG_DATA_DIRS="/etc/xdg/op:/usr/local/share:/usr/share:@_datadir_@"
else
  XDG_DATA_DIRS="$XDG_DATA_DIRS:@_datadir_@"
  XDG_DATA_DIRS="/etc/xdg/op:$XDG_DATA_DIRS:@_datadir_@"
fi
export XDG_DATA_DIRS

# Use FreeDesktop XDG dir vars to put user data in non hidden dirs to make
# maintaince easier for users.
# These really should be set somewhere better but for now this will work.
export XDG_DATA_HOME=$HOME/Applications/Data
export XDG_CONFIG_HOME=$HOME/Applications/Settings
export XDG_CACHE_HOME=$HOME/Applications/Cache

#HACK: Run Xsession.d from here :-o
#Wrong, wrong, wrong but it works and sorting out OE's X server chain is not going to happen right now.

if [ -d /etc/X11/Xsession.d ]; then
    for i in `ls /etc/X11/Xsession.d/` ; do
        if [ -r "/etc/X11/Xsession.d/$i" ] && expr "$i" : '^[[:alnum:]_-]\+$' > /dev/null; then
            . "/etc/X11/Xsession.d/$i"
        fi
    done
fi

#Load up the proper keymap for X
xmodmap ~/.pndXmodmap

#Write the current user into /tmp/currentuser for any scripts or programs who want to make use of it
whoami > /tmp/currentuser
id -u > /tmp/currentuid
chmod 777 /tmp/currentuser
chmod 777 /tmp/currentuid

# HUP pndnotifyd to make sure it picks up the users home.
killall -1 pndnotifyd &

# The following variable defines the session which is started if the user
# doesn't explicitely select a session in SLiM.

DEFAULT_SESSION=startxfce4
STOP_SESSION="xfce4-session-logout --logout"

# Write the default session into a temporary file.
# This way, we can easily add new sessions in the future by just
# setting the DEFAULT_SESSION to the executable or script.

echo $DEFAULT_SESSION > /tmp/gui.load

# If SLiM does pass a variable, use that. Otherwise use our DEFAULT_SESSION.

SESSION=$1

if [ "$SESSION" == "" ]

	then
	SESSION=$(cat /tmp/gui.load)
fi

STOP_SESSION=$(grep $SESSION /etc/pandora/conf/gui.conf | awk -F\; '{print $4}')
echo $STOP_SESSION > /tmp/gui.stop
chmod +x /tmp/gui.stop

# Disable screen blanking if uncommented
# DISPLAY=:0 xset s off

# Starts our session and checks if a new session should be loaded
# after the old one is quit by simply executing the command that's in /tmp/gui.load

# This way, we can easily do a quick switch from any session to the next one by simply
# echo'ing the new session executable into /tmp/gui.load and exiting.

if [ -f /tmp/nocleanwarn ]; then
    defmhz="$(cat /etc/pandora/conf/cpu.conf | grep default | awk -F\: '{print $2}')"
      if [ $defmhz -gt 600 ]; then
	zenity --info --title="Unclean Shutdown" --text "Warning!\n\nThe system has not been shutdown properly last time.\n\nAs you overclocked the CPU as default speed, this might be the reason for that.\nTherefore, for this session, the current CPU speed has been set to 500 MHz."
      fi
  rm /tmp/nocleanwarn
 fi
while true
do
	rm /tmp/gui.load

	if [ "$SESSION" == "" ]

	then
		exit 0;
	fi

	$SESSION
        
	SESSION=$(cat /tmp/gui.load)
	STOP_SESSION=$(grep $SESSION /etc/pandora/conf/gui.conf | awk -F\; '{print $4}')
        echo $STOP_SESSION > /tmp/gui.stop
        chmod +x /tmp/gui.stop
done
