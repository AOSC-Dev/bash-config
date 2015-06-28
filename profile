# Begin /etc/profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.  Personal
# environment variables and startup programs should go into
# ~/.bash_profile.  Personal aliases and functions should go into
# ~/.bashrc.

_IFS="$IFS" IFS='
'
export PATH MANPATH

for pth in $(cat /etc/paths.d/._* /etc/paths /etc/paths.d/*); do
	[ "${pth:0:1}" != '#' ] && PATH="$PATH:$pth"
done 2>/dev/null

for pth in $(cat /etc/manpaths.d/._* /etc/manpaths /etc/manpaths.d/*); do
	[ "${pth:0:1}" != '#' ] && MANPATH="$MANPATH:$pth"
done 2>/dev/null
: ${PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin}
: ${MANPATH=/usr/share/man:/usr/local/share/man}

# Set the initial path
if [ $EUID -eq 0 ] ; then
	pathappend /sbin:/usr/sbin
	unset HISTFILE
fi

# Setup some environment variables.
export HISTFILESIZE=4096

# Timezone variable $TZ, Wine and stuff alike need it.
export TZ="$(readlink /etc/localtime | sed 's/^\.\.//g' | sed "s/\/usr\/share\/zoneinfo\///")"

for script in /etc/profile.d/* ; do
	[ -r $script ] && . $script
done

# Now to clean up
unset pth script
IFS="$_IFS"
# End /etc/profile
