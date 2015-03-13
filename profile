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

for script in /etc/profile.d/*.sh ; do
        if [ -r $script ] ; then
                . $script
        fi
done

# Recorder
LASTDIR=yes

# Provides a colored /bin/ls command.  Used in conjunction with code in /etc/profile.
alias l='ls -alh'
alias ll='ls -lh'
alias la='ls -a'
for c in {e,f,}grep {v,}dir ls; do alias $c="$c --color=auto"; done; unset c

# Systemd specific, as cutting off output sounds like a silly idea.

# which(){ (alias; declare -F) | /usr/bin/which -i --read-functions "$@"; }

# Provides prompt for non-login shells, specifically shells started
# in the X environment. 
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
CYAN="\[\e[1;36m\]"

# Linux tty color
if [ `tput colors`=="8" ]; then
    YELLOW='\e[1;33m'
else
    YELLOW='\e[1;93m'
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

_ret_same() {
    return $?;
}

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

# Completion, wow.
[ -e /usr/share/bash-completion/bash_completion ] && \
    . /usr/share/bash-completion/bash_completion

# Extra Aliases for those lazy ones :)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias nano='nano -w'

# Last directory recoding measure.
_last_dir() {
    local _ret=0
    cd $(cat ~/.last_directory)
    return $_ret
}

if [ "$LASTDIR" = "yes" ]; then
    if [ -e ~/.last_directory ]; then
        if [ -s ~/.last_directory ]; then
            if [ -d $(cat ~/.last_directory) ]; then
                printf "$YELLOW>>>\t\033[36mReturning you to the last directory...\033[0m \"`cat ~/.last_directory`\"\n"
                _last_dir
            else
                printf "$YELLOW>>>\t\033[36mLast recorded directory cannot be accessed or was already removed,\n\treturning to \033[0m$HOME \033[36m...\033[0m\n"
                cd $HOME
            fi
        else
            printf "$YELLOW>>>\t\033[36mLast record empty?! Go back to your home!\033[0m\n"
            cd $HOME
        fi
    else
        true
    fi
else
    true
fi

_record() {
    printf "$YELLOW>>>\t\033[36mRecording your current working directory...\033[0m\n"
    echo $PWD | tee > ~/.last_directory
    return 0
}

trap _record EXIT

# Now to clean up
unset pathremove pathprepend pathappend

# End /etc/profile
