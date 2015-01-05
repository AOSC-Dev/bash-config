# Begin /etc/bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Then improved and changed to fit AOSC OSes
# By Jeff Bai and Arthur Wang

# System wide aliases and functions.

# System wide environment variables and startup programs should go into
# /etc/profile.  Personal environment variables and startup programs
# should go into ~/.bash_profile.  Personal aliases and functions should
# go into ~/.bashrc

# Provides a colored /bin/ls command.  Used in conjunction with code in /etc/profile.

. /etc/profile
alias l='ls -alh'
alias ll='ls -lh'
alias la='ls -a'
for c in {e,f,}grep {v,}dir ls; do alias $c="$c --color=auto"; done; unset c
# which(){ (alias; declare -F) | /usr/bin/which -i --read-functions "$@"; }

# Provides prompt for non-login shells, specifically shells started
# in the X environment. 

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
CYAN="\[\e[1;36m\]"
# Linux tty color
if [ `tput colors`=="8" ] 
then YELLOW='\e[1;33m'
else YELLOW='\e[1;93m'
fi

# A simple error level reporting function.
# Loaded back to PS1

_ret_prompt() {
  # Now we worry nothing about $_ret.
  case $? in
    0|130) # Input C-c
      [[ $EUID == 0 ]] && printf '#' || printf '$'
      ;;
    127) # Command not found
      printf '\e[1;36m?'
      ;;
    *)
      printf $YELLOW'!'
      ;;
  esac
}

_ret_same() { return $?; }
. /etc/bashrc_repo &>/dev/null || alias _repo_status='_ret_same' # Fallback
# To be shipped together. See comments in bashrc_repo on _ret and _ret_status().

# Use "\w" if you want the script to display full path
# How about using cut to "\w($PWD)" to give path of a certain depth?
  # Well, forget it.
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u $NORMAL[ \W\$(_repo_status) ]$RED \$(_ret_prompt) $NORMAL"
else
  PS1="$GREEN\u $NORMAL[ \W\$(_repo_status) ]$GREEN \$(_ret_prompt) $NORMAL"
fi

# Completion, wow
[ -e /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Extra Aliases for those lazy ones :)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias nano='nano -w'
# End /etc/bashrc
