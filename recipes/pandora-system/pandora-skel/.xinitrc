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

# The following variable defines the session which is started if the user
# doesn't explicitely select a session in SLiM.

DEFAULT_SESSION=startxfce4

case $1 in
xfce4)
	exec startxfce4
	;;
pmenu)
	exec pmenu
	;;
*)
	exec $DEFAULT_SESSION
	;;
esac
