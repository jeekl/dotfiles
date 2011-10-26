#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# Load global xinit configurations
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

run_daemon () {
    pidof "$1" && killall "$1" && sleep 3
    (exec "$@") &
}


# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#xrandr --output DisplayPort-0 --off --output DVI-1 --mode 1920x1080 --pos 1936x0 --rotate normal --output DVI-0 --off --output HDMI-0 --mode 1680x1050 --pos 0x0 --rotate normal
xrandr --output DisplayPort-0 --off --output DVI-1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --off --output DVI-0 --mode 1920x1080 --pos 1936x0 --rotate normal

## Set keyboard mapping.
## TODO: make individual xkb-maps for all the different keyboards and machines I use.
#setxkbmap se
#setxkbmap -option terminate:ctrl_alt_bksp &  # C-M-<Backspace> kills X.
xkbcomp -I$HOME/conf/xkb $HOME/conf/xkb/hhkb2.xkb $DISPLAY


xset s off &             # turn screen blankin of
urxvtd -q -f -o
xmodmap .Xmodmap
#setxkbmap -option ctrl:swapcaps

(sleep 3 && xmodmap $HOME/.Xmodmap) &

dropboxd &

rvm use 1.9.2@general

# Start dbus to get automounting in thunar.
#if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
#    eval `dbus-launch --sh-syntax --exit-with-session`
#fi

#exec ck-launch-session xmonad
#exec subtle
#exec ck-launch-session gnome-session
#exec /usr/local/bin/stumpwm


case "${1}" in
subtle)
    exec subtle
;;
stumpwm)
    exec /usr/local/bin/stumpwm
;;
gnome)
    exec ck-launch-session gnome-session
;;
*)
    (sleep 3 && stalonetray --geometry 1x1+1660+0 -i 16 -bg '#212121' --window-type dock --grow-gravity NE --icon-gravity E) &
    run_daemon thunar --daemon
    nitrogen --restore &
    xsetroot -cursor_name left_ptr
		
    exec ck-launch-session xmonad
;;
esac

