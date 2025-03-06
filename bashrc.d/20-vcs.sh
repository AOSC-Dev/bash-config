# 20-vcs, the version control display for AOSC OS PS1.
# by Arthur Wang

# This module is highly extensible. Just read the source.
# Long-term TODO: svn, vns and bzr.

# We are not POSIX-compatible.
_is_posix && return

# Get functions
if [ -e /etc/bashrc.d/_vcs ]; then
	for _vcs in /etc/bashrc.d/_vcs/*; do
		. "$_vcs"
		_vcs_mods+=" $(basename ${_vcs})"
	done
else
	_vcs_status(){ true; }
	unset _vcs_files
	return
fi
unset _vcs

# Output
_vcs_status() {
	_ret=$?
	local _vcs
	for _vcs in $_vcs_mods; do
		_ps1_"$_vcs"_status && break
	done
	return $_ret
}
