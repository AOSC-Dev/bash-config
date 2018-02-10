# Set locale for legacy desktop environments that do not respect localectl.
# TODO: export and fallback all the stuffs as defined in locale.conf(7).
[ -f /etc/locale.conf ] && . /etc/locale.conf
export LANG
if test -z "${XDG_RUNTIME_DIR}"; then
    if test -d "/run/user/${UID}"; then
        # Systemd uses this as XDG_RUNTIME_DIR
        export XDG_RUNTIME_DIR=/run/user/${UID}
    else
        export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
        if ! test -d "${XDG_RUNTIME_DIR}"; then
            mkdir -p "${XDG_RUNTIME_DIR}"
            chmod 0700 "${XDG_RUNTIME_DIR}"
        fi
    fi
fi

