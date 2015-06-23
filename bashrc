# Begin /etc/bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Then improved and changed to fit AOSC OSes
# By Jeff Bai and Arthur Wang

# System wide aliases and functions.
[ "$BASH" ] || shopt(){ return ${shopt_def-0}; }
_is_posix(){ shopt -oq posix; }

# System wide environment variables and startup programs should go into
# /etc/profile.  Personal environment variables and startup programs
# should go into ~/.bash_profile.  Personal aliases and functions should
# go into ~/.bashrc

. /etc/profile

# Provides prompt for non-login shells, specifically shells started
# in the X environment. 

# Make bash append rather than overwrite the history on disk
# Allows user to edit a failed hist exp.
# Allows user to verify the results of hist exp.
shopt -s histappend histreedit histverify
HISTIGNORE='&:[bf]g:exit'
HISTCONTROL='ignorespace'

# When changing directory small typos can be ignored by bash
# Chdirs into it if command is a dir
# Chdirs into $var if var not found
shopt -s cdspell autocd cdable_vars

# Do not complete when readline buf is empty
shopt -s no_empty_cmd_completion 

# Extended glob (3.5.8.1) & find-all-glob with **
shopt -s extglob globstar

# Hashtable the commands!
shopt -s checkhash

# Colors
alias l='ls -AFlh'
alias ll='ls -Flh'
alias la='ls -AF'
for c in {e,f,}grep {v,}dir ls; do alias $c="$c --color=auto"; done;

# So they can be unset.
_aosc_bashrc_colors='NORMAL RED GREEN CYAN IRED YELLOW'
NORMAL='\[\e[0m\]'
RED='\[\e[1;31m\]'
GREEN='\[\e[1;32m\]'
CYAN='\[\e[1;36m\]'

# Linux tty color workaround
[ "$(tput colors)" == 8 ] && YELLOW='\e[1;33m' IRED="\e[0;31m" || YELLOW='\e[1;93m' IRED="\e[0;91m"

# A simple error level reporting function.
# Loaded back to PS1
_ret_prompt() {
  case $? in
    0|130) # Input C-c
      ((EUID)) && printf '$' || printf '#' ;;
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

if [[ "$EUID" == 0 ]] ; then
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
alias ed='ed -p: -v' # ED for Eununchs hackers.
_is_posix || which(){ (alias; declare -F) | /usr/bin/which -i --read-functions "$@"; }

# Misc stuffs
FIGNORE='~'
TIMEFORMAT=$'\nreal\t%3lR\t%P%%\nuser\t%3lU\nsys\t%3lS'
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
unalias shopt
# End /etc/bashrc
