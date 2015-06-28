# Setup the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
    INPUTRC=/etc/inputrc
fi
export INPUTRC

# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
    umask 002
else
    umask 022
fi

if [ -d ~/bin ]; then
    PATH="$HOME/bin:$PATH"
fi
