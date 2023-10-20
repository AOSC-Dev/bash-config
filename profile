# Begin /etc/profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.  Personal
# environment variables and startup programs should go into
# ~/.bash_profile.  Personal aliases and functions should go into
# ~/.bashrc.

# Source profile scripts
for script in /etc/profile.d/* ; do
	case "$script" in
		*.bash)
			[ "$BASH" ] && . "$script" ;;
		*.sh)
			. "$script" ;;
	esac
done

# Now to clean up
unset pth script
# End /etc/profile
