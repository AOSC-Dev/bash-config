# Begin /etc/bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Then improved and changed to fit AOSC OS.
# By Mingcong Bai and Arthur Wang.

# System wide aliases and functions.
[ "$BASH" ] || shopt(){ return ${shopt_def-0}; }
_is_posix(){ shopt -oq posix; }

# System wide environment variables and startup programs should go into
# /etc/profile.  Personal environment variables and startup programs
# should go into ~/.bash_profile.  Personal aliases and functions should
# go into ~/.bashrc

# Provides prompt for non-login shells, specifically shells started
# in the X environment.

# Setting shell options:
#
# - Make bash append rather than overwrite the history on disk.
# - Allows user to edit a failed hist exp.
# - Allows user to verify the results of hist exp.
# - When changing directory small typos can be ignored by bash.
# - Chdirs into it if command is a dir.
# - Do not complete when readline buf is empty.
# - Extended glob (3.5.8.1) & find-all-glob with **.
# - Hashtable the commands!
# - Winsize.
shopt -s \
    histappend \
    histreedit \
    histverify \
    cdspell \
    autocd \
    no_empty_cmd_completion \
    extglob \
    globstar \
    checkwinsize
HISTIGNORE='&:[bf]g:exit'
HISTCONTROL='ignorespace'

# Disable executable path hashing. It gets confusing quickly, as the same
# command can in fact exist in multiple PATH locations.
set +h

# Colors
alias l='ls -AFlh'
alias ll='ls -Flh'
alias la='ls -AF'
for c in {e,f,}grep {v,}dir ls; do alias $c="$c --color=auto"; done

# ip color
alias ip='ip --color=auto'

# space and time efficient cp
alias cp='cp --reflink=auto --sparse=always'

# So they can be unset.
# I need someone to help me assign those names properly.
# Those are actually bold colors.
_aosc_bashrc_colors='NORMAL BOLD RED GREEN CYAN IRED YELLOW'
NORMAL='\e[0m'
BOLD='\e[1m'
RED='\e[1;31m'
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;93m'
IRED='\e[0;91m'

if _rc_term_colors="$(tput colors)"; then
	[ "$_rc_term_colors" -le 16 ]
else
	case "$TERM" in (linux|msys|cygwin) true;; (*) false;; esac
fi && YELLOW='\e[1;33m' IRED='\e[0;31m'
unset _rc_term_colors

# if our TERM has no color support, then unset $_aosc_bashrc_colors

# A simple error level reporting function.
# Loaded back to PS1
_ret_prompt() {
  case $? in
    0|130)	# Input C-c, we have to override the \$
      ((EUID)) && echo -n '$' || echo -n '#';;
    127)	# Command not found
      echo -ne '\01\e[1;36m\02?'
      ;;
    *)		# Other errors
      echo -ne '\01'$YELLOW'\02!'
      ;;
  esac
}

_ret_same() { return $?; }

_ssh_session() {
	# Store error code.
	err="$?"
	# This if branch would overwrite the current error code.
	if [[ x"${SSH_CONNECTION:-}" != "x" ]]; then
		echo '(ssh)'
	fi
	# Load error code.
	return "$err"
	unset err
}

# Set up PATH and MANPATH
# WSL compatibility (retain PATH from Windows host).
if [[ ! -v WSL_DISTRO_NAME ]]; then
	unset PATH
fi
unset MANPATH

# WSL compatibility (retain PATH from Windows host).
if [[ ! -v WSL_DISTRO_NAME ]]; then
	: ${PATH=$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin}
else
	: ${PATH=$PATH:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin}
fi
: ${MANPATH=/usr/share/man:/usr/local/share/man}
export PATH MANPATH

# Base functions ready. Let's load bashrc.d.
for script in /etc/bashrc.d/!(_vcs); do . "$script"; done

# The prompt depends on vcs_status! Get one backup anyway.
type _vcs_status &>/dev/null || \
    alias _vcs_status=_ret_same

# To be shipped together. See comments in bashrc_repo on _ret and _ret_status().

# Use "\w" if you want the script to display full path
# How about using cut to "\w($PWD)" to give path of a certain depth?
# Well, forget it.

if [[ "$EUID" == 0 ]] ; then
  PS1="\[$YELLOW\]\$(_ssh_session)\[$NORMAL\]\[$RED\]\u\[$NORMAL\]\[$BOLD\]@\[$NORMAL\]\h [ \W\$(_vcs_status) ]\[$RED\] \$(_ret_prompt) \[$NORMAL\]"
else
  PS1="\[$YELLOW\]\$(_ssh_session)\[$NORMAL\]\[$GREEN\]\u\[$NORMAL\]\[$BOLD\]@\[$NORMAL\]\h [ \W\$(_vcs_status) ]\[$GREEN\] \$(_ret_prompt) \[$NORMAL\]"
fi

# Extra Aliases for those lazy ones :)
gen_dotdotdot() {
	local _i='cd ..'
	local _ii='..'
	for i in {0..16}; do
		alias $_ii="$_i"
		_i+='/..'
		_ii+='.'
	done
}
gen_dotdotdot
alias nano='nano -w -u'
alias ed='ed -p: -v'

# A standard alias for which (debianutils vs GNU)
_is_posix || which --version 2>/dev/null | grep -q GNU && alias which='(alias; declare -f) | which -i --read-functions'

# Misc stuffs
FIGNORE='~'
TIMEFORMAT=$'\nreal\t%3lR\t%P%%\nuser\t%3lU\nsys\t%3lS'

_IFS='  
' # $' \t\n'
IFS='
' # $'\n'
for pth in $(cat /etc/paths.d/._* /etc/paths /etc/paths.d/*); do
        case "$pth" in \#*) continue;; esac
        PATH="$PATH:$pth"
done 2>/dev/null

for pth in $(cat /etc/manpaths.d/._* /etc/manpaths /etc/manpaths.d/*); do
        case "$pth" in \#*) continue;; esac
        MANPATH="$MANPATH:$pth"
done 2>/dev/null
IFS="$_IFS"

# Setup some environment variables.
export HISTFILESIZE="${HISTFILESIZE:-4096}"

# Timezone variable $TZ, Wine and stuff alike need it.
export TZ="$(readlink /etc/localtime | sed -e 's/^\.\.//g' -e 's@/usr/share/zoneinfo/@@')"

unset pth script shopt
# End /etc/bashrc
