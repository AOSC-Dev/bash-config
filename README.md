BASH_PS1_MISC
=============

Generic Bash PS1 (bashrc) Configuration

bashrc
---
The main bashrc file.

bashrc\_git
---
Provides `git branch` PS1 function.

Preview
---
Error:
* <font color=green>user</font>[ ~/git@<font color=red>notcommited</font> ]<font color=yellow>!</font>

Command not found:
* <font color=red>root</font>[ ~/foo@<font color=green>nothingToCommitBranch</font> ]<font color=cyan>?</font>

Normal:
* <font color=red>root</font>[ ~/bar@<font color=green>BarBranch</font> ]<font color=red>#</font>
* <font color=green>user</font>[ ~/nogit ]<font color=green>$</font>
