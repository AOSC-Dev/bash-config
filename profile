# Begin /etc/profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.  Personal
# environment variables and startup programs should go into
# ~/.bash_profile.  Personal aliases and functions should go into
# ~/.bashrc.

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
	local IFS=':'
	local NEWPATH
	local DIR
	local PATHVARIABLE=${2:-PATH}
	for DIR in ${!PATHVARIABLE} ; do
		if [ "$DIR" != "$1" ] ; then
		  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
		fi
	done
	export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
	pathremove $1 $2
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
	pathremove $1 $2
	local PATHVARIABLE=${2:-PATH}
	export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}


# Set the initial path
export PATH=/bin:/usr/bin

if [ $EUID -eq 0 ] ; then
	pathappend /sbin:/usr/sbin
	unset HISTFILE
fi

# Setup some environment variables.
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# Timezone variable $TZ, Wine and stuff alike need it.
export TZ="$(readlink /etc/localtime | sed 's/^\.\.//g' | sed "s/\/usr\/share\/zoneinfo\///")"

# And sync this setting onto /etc/timezone for weird stuff like indicator-datetime.
echo $TZ > /etc/timezone

for script in /etc/profile.d/*.sh ; do
	[ -r $script ] && . $script
done

# Now to clean up
unset pathremove pathprepend pathappend script

# End /etc/profile
