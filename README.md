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

By default, it reads bashrc\_foo to load the repo status function for foo version
control system.

###bashrc\_git
Provides git branch and status info in the PS1.

Also provides aliases.

###bashrc\_hg
Provides hg branch and status info in the PS1.

Also provides aliases.

Porting to other platforms
---
The master branch of this repo can be easily ported to other platforms with bash and an echo with -e flag.

If you use BSD coreutils, just change `ls --color=auto` to `ls -G`.<br />
If you use OS X or wants to make an OS X distribution, you had better include the workaround
mentioned [Here](https://github.com/AOSC-Dev/BASH_PS1_MISC/issues/3), the issue #3, in order to 
avoid the "Please install XCode Developer Tools" from appearing too many times.

This package provides an example: [Bash 4.3 for OS X](http://pan.baidu.com/s/1c0xlkFu)
