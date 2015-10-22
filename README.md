bash-config
===========

AOSC's bash & sh startup files in `/etc`.

Features
--------

* Colored PS1 with VCS branch display and return-value based prompt
  ![bashrc with git, commit b9913ca](http://ibin.co/1QscpgR0BOyN)
* OS X-like `/etc/paths` management scheme.
* Regular `somefile.d` directorys.
* Common aliases.

Structure
---------

* `bashrc` - Bash's global startup file, sourced by `~/.bashrc`. Contains
  stuffs that we think is good for all users.
  * Sources `profile` for environmental variables
  * Sets some variables for colors
  * Sources `bashrc.d`
  * Sets up the PS1
  * Sets up aliases
  * Sets up some bash-specific variables.
* `profile` - Environment variables for all POSIX login shells
  * Sets up `$PATH` and `$MANPATH`:
    * Ignores lines starting with `#`.
    * Adds each line of `/etc/paths.d/._pre*` to `$PATH`,
	* Adds each line of `/etc/paths` to `$PATH`,
	* Adds each line of `/etc/paths.d/*` to `$PATH`.
	* Then do almost the same for `manpaths`.
    * If those are still empty, default values `{,/usr{,/local}}/{s,}bin` and
	  `/usr/{,local/}man` are used.
  * Sets up `$TZ` and some common history variables.
  * Sources `profile.d`.
* `skel` - `$HOME` Skeleton. Contains what we think is good for most users.
  * `.bashrc` - User bash startup, sources `/etc/bashrc`.
  * `.bash_profile` - User bash login, sources `~/.bashrc`.
  * `.bash_logout` - User bash logout.
* `bashrc.d` - Files sourced by `/etc/bashrc`.
  * `20-vcs` - VCS aliases and PS1. Provides `_vcs_status`.
    * `.vcs_*` - VCS Implementations.
* `profile.d` - Files sourced by `/etc/profile`.

Dependencies
------------

* GNU Bash for `bashrc` stuffs. When we are happy, we try to make most parts of
  `bashrc` compatible with other bourne/POSIX-like shells, e.g. `hush`/`ash`.
* At least a mostly POSIX-compatible shell for `profile`. We try our best to
  guarantee that it's written fully POSIXly. Send us an issue if it's not.
* Coreutils for `profile`. More specifically, `cat`, `sed` and `mkdir`.
  GNU/Busybox ones are preferred. See [#Porting](#Porting) for more info.

Invocation
----------

This briefly describes how bash processes the files. and put here as a sort of
reference:

On Startup:
```Bash
# Pseudo-code functions:
# _bash_optarg: The argument for an option.
# _bash_opts: If this option is set.
_is_sh(){ [ "$(basename "$BASH")" == "sh" ]; }
_is_posix(){ shopt -oq posix; }
_is_interactive() { case "$-" in *i*) return 0; esac; return 1; }
_is_login(){ [ "${0:0:1}" == - ] || _bash_opts --login || _bash_opts -l; }
# Real bash doesn't change the return value, just for convenience with ||
load_if_exists(){ [ -r "$1" ] || return 1; . "$@"; true; }
if _is_interactive; then
  if _is_login && ! _bash_opts --noprofile; then
    load_if_exists /etc/profile
    if ! _is_sh; then
      load_if_exists ~/.bash_profile ||
      load_if_exists ~/.bash_login ||
      load_if_exists ~/.profile
    else
      load_if_exists ~/.profile
    fi
  elif ! _bash_opts --norc; then
	if ! _is_posix; then
		_is_sh || load_if_exists "$(_bash_optarg --rcfile || echo ~/.bashrc)"
	else
		load_if_exists "$ENV"
	fi
  elif _is_network_input; then
    is_sh || load_if_exists ~/.bashrc
  fi
# Non-interactive (i.e. To run a script) 
else
  if ! _is_sh; then
    load_if_exists "$BASH_ENV"
  fi
fi
_is_sh && shopt -os posix
```

On exit:
```Bash
if _is_login && ! _is_sh && ! _is_posix; then
  load_if_exists ~/.bash_logout
fi
```

Porting
-------

The master branch of this repo can be easily ported to other platforms
with bash and an echo with -e flag. For earlier bash without `\e` escaping,
perform `sed -i -e 's@\\e@\\33@g' **` on the tree.

If you use BSD coreutils, change `ls --color=auto` to `ls -G`.

If you use OS X or wants to make an OS X distribution, you had better include
the workaround mentioned in
[#3](https://github.com/AOSC-Dev/bash-config/issues/3),
in order to avoid "Please install XCode Developer Tools"
from appearing too many times.

This package provides an example:
[Bash 4.3 for OS X](http://pan.baidu.com/s/1c0xlkFu).

F@Q
---

Those are questions collected over time. I got tired answering this, although
some people like @Icenowy keeps annoying me with those.

### Why did I get a command `lastdir` not found error on logout?

Because including it was a mistake. Replace corresponding file(s) with those
in `/etc/skel`, so just run `cat /etc/skel/.bash_logout > ~/.bash_logout`.

### Why are you breaking things?

Because AOSC OS itself is beta. Luckily, although it comes with no warrenty,
documented things will not be changed frequently. Data loss should be super
rare, or *epic*, too. Even us use it on production environment.

If those things happens to you, we can buy you some lolipop. You can also open
_Love Live_ and perform a 11-time recruit.
