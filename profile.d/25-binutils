# Setup for /bin/ls to support color, the alias is in /etc/bashrc.
if [ "$LS_COLORS" ]; then
    :
elif [ -f "/etc/dircolors" ]; then
    eval "$(dircolors -b /etc/dircolors)"
elif [ -f "$HOME/.dircolors" ] ; then
    eval "$(dircolors -b "$HOME/.dircolors")"
else
    eval "$(dircolors -b)"
fi
