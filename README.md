BASH_PS1_MISC
=============

Generic Bash PS1 (bashrc) Configuration

![bashrc with git, commit b9913ca](http://ibin.co/1QscpgR0BOyN)

bashrc
---
The main bashrc file.

bashrc\_repo
---
Provides repo branch/status PS1 function.

###bashrc_git
Provides git branch and status info in the PS1.

Also provides aliases.

###bashrc_hg
Provides hg branch and status info in the PS1.

Also provides aliases.

Porting to other platforms
---
The master branch of this repo can be easily ported to other platforms with bash and an echo with -e flag.

If you use BSD coreutils, just change `ls --color=auto` to `ls -G`.

This package provides an example: [Bash 4.3 for OS X](http://pan.baidu.com/s/1pJAvUHl)
