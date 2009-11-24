#HACK: Run Xsession.d in this place :-o

SYSSESSIONDIR=/etc/X11/Xsession.d
run-parts $SYSSESSIONDIR

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
