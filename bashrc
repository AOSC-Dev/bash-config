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

. /etc/profile
# Systemd specific, as cutting off output sounds like a silly idea.

# which(){ (alias; declare -F) | /usr/bin/which -i --read-functions "$@"; }

# Provides prompt for non-login shells, specifically shells started
# in the X environment. 

# Colors
alias l='ls -AFlh'
alias ll='ls -Flh'
alias la='ls -AF'
for c in {e,f,}grep {v,}dir ls; do alias $c="$c --color=auto"; done;

NORMAL='\[\e[0m\]'
RED='\[\e[1;31m\]'
GREEN='\[\e[1;32m\]'
CYAN='\[\e[1;36m\]'

# Linux tty color workaround
[ $(tput colors) == 8 ] && YELLOW='\e[1;33m' IRED="\e[0;31m" || YELLOW='\e[1;93m' IRED="\e[0;91m"

# A simple error level reporting function.
# Loaded back to PS1
_ret_prompt() {
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

# Base functions ready. Let's load bashrc.d.
for c in /etc/bashrc.d/*; do . $c; done 

# The prompt depends on repo_status! Get one backup anyway.
declare -f _repo_status >/dev/null || ! echo _repo_status not declared, making stub.. || alias _repo_status=_ret_same

# To be shipped together. See comments in bashrc_repo on _ret and _ret_status().

# Use "\w" if you want the script to display full path
# How about using cut to "\w($PWD)" to give path of a certain depth?
 # Well, forget it.

if [[ $EUID == 0 ]] ; then
  PS1="$RED\u $NORMAL[ \W\$(_repo_status) ]$RED \$(_ret_prompt) $NORMAL"
else
  PS1="$GREEN\u $NORMAL[ \W\$(_repo_status) ]$GREEN \$(_ret_prompt) $NORMAL"
fi

# Completion, wow.
shopt -oq posix || [ -e /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Extra Aliases for those lazy ones :)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias nano='nano -w'

# Last directory recoding measure.
_lastdir_go() {
  if [ -s ~/.last_directory ]; then
    if [ -d $(cat ~/.last_directory) ]; then
      echo -e "$YELLOW>>>\t${CYAN}Returning you to the last directory...$NORMAL \`$(cat ~/.last_directory)'"
      cd $(cat ~/.last_directory)
    else
      echo -e "$YELLOW>>>\t${CYAN}Last recorded directory cannot be accessed or was already removed.$NORMAL"
    fi
  fi
}

_lastdir_rec() {
    local _ret=$? # Return value transparency is actually important here
    echo -ne "$YELLOW>>>\t\033[36mRecording your current working directory...\033[0m"
    pwd > ~/.last_directory
    return $_ret
}

unset c
# End /etc/bashrc
