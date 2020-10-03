# Begin /etc/profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.  Personal
# environment variables and startup programs should go into
# ~/.bash_profile.  Personal aliases and functions should go into
# ~/.bashrc.

# Set up PATH and MANPATH
unset PATH MANPATH
_IFS=' 	
' # $' \t\n'
IFS='
' # $'\n'
for pth in $(cat /etc/paths.d/!(*.dpkg*) /etc/paths); do
	case "$pth" in \#*) continue;; esac
	PATH="$PATH:$pth"
done 2>/dev/null

for pth in $(cat /etc/manpaths.d/!(*.dpkg*) /etc/manpaths); do
	case "$pth" in \#*) continue;; esac
	MANPATH="$MANPATH:$pth"
done 2>/dev/null
IFS="$_IFS"

: ${PATH=/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin}
: ${MANPATH=/usr/share/man:/usr/local/share/man}
export PATH MANPATH

# Setup some environment variables.
export HISTFILESIZE=4096

# Timezone variable $TZ, Wine and stuff alike need it.
export TZ="$(readlink /etc/localtime | sed -e 's/^\.\.//g' -e 's@/usr/share/zoneinfo/@@')"

# Source profile scripts
for script in /etc/profile.d/!(*.dpkg*) ; do
	case "$script" in
		*.csh)  # No! Go away, csh!
			continue;;
		*.bash)
			[ "$BASH" ] || continue;;
	esac
	[ -r "$script" ] && . "$script"
done

# Now to clean up
unset pth script
# End /etc/profile
