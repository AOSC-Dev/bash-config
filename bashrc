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

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
CYAN="\[\e[1;36m\]"
YELLOW="\[\e[1;33m\]"

# A simple error level reporting function.
# Loaded back to PS1

if [[ $EUID == 0 ]] ; then
  PS1="\$(if [[ \$? == 0 ]]; then echo \"$CYAN>>> $NORMAL\$?\"; else echo \"$YELLOW-!- $NORMAL\$?\"; fi) $RED\u $NORMAL[ \W ]$RED $RED# $NORMAL"
else
  PS1="\$(if [[ \$? == 0 ]]; then echo \"$CYAN>>> $NORMAL\$?\"; else echo \"$YELLOW-!- $NORMAL\$?\"; fi) $GREEN\u $NORMAL[ \W ]$RED $GREEN\$ $NORMAL"
fi

# Extra Aliases for those lazy ones :)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias nano='nano -w'
# End /etc/bashrc
