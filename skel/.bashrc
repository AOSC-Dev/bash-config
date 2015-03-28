# Begin ~/.bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal aliases and functions.

# Personal environment variables and startup programs should go in
# ~/.bash_profile.  System wide environment variables and startup
# programs are in /etc/profile.  System wide aliases and functions are
# in /etc/bashrc.

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi

if [[ "$LASTDIR" == yes && -s ~/.last_directory ]]; then
  if [ -d $(cat ~/.last_directory) ]; then
    echo -e "$YELLOW>>>\t\033[36mReturning you to the last directory...\033[0m \`$(cat ~/.last_directory)'"
    _last_dir
  else
    echo -e "$YELLOW>>>\t\033[36mLast recorded directory cannot be accessed or was already removed.\033[0m"
  fi
fi

# End ~/.bashrc
