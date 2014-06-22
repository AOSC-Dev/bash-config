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

# Provides a colored /bin/ls command.  Used in conjunction with code in
# /etc/profile.

alias ls='ls --color=auto'
alias l='ls -alh'
alias ll='ls -lh'
alias la='ls -a'

alias grep='grep --color=auto'

# Provides prompt for non-login shells, specifically shells started
# in the X environment. 

TERMCOLOR=`tput colors`

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
CYAN="\[\e[1;36m\]"
# Linux tty color
if [ "$TERMCOLOR"=="8" ] 
then YELLOW="\e[1;33m"
else YELLOW="\e[1;93m"
fi

# A simple error level reporting function.
# Loaded back to PS1

_ret_prompt() {
  _ret=$?
  if ([[ $_ret != 127 ]] && [[ $_ret != 0 ]])
  then 
    echo -e "$YELLOW\x21"
  elif [[ $_ret == 127 ]] 
  then 
    echo -e "\e[1;36m?"
  elif [[ $EUID == 0 ]]
  then 
    echo "#"
  else 
    echo "\$"
  fi
}

. /etc/bashrc_git &>/dev/null || true # To be included in the package"git"
_git_branch &>/dev/null

# Declare an empty one if git is not installed.
if [[ $? != 0 ]]; then alias _git_branch='true'; fi

# Use "\w" if you want the script to display full path
# How about using cut to "\w($PWD)" to give path of a certain depth?
  # Well, forget it.
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u $NORMAL[ \W\$(_git_branch) ]$RED \$(_ret_prompt) $NORMAL"
else
  PS1="$GREEN\u $NORMAL[ \W\$(_git_branch) ]$GREEN \$(_ret_prompt) $NORMAL"
fi

# Extra Aliases for those lazy ones :)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias nano='nano -w'
# End /etc/bashrc
