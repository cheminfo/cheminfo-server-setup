
message "Force locale to en_US.UTF-8 during installation"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8
ok

message "Updating packages"
if
    yum --assumeyes update >> $LOG
then
    ok
else
    error
fi

message "Installing zip, epel-release, git, screen, xz"

if
    yum --assumeyes install zip epel-release git screen xz >> $LOG
then
    ok
else
    error
fi


message "Disabling IPv6"

if
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 >$LOG &&
    sysctl -w net.ipv6.conf.default.disable_ipv6=1 >$LOG
then
    ok
else
    error
fi

message "Copying custom bashrc"

if
    cp "${DIR}/configs/cheminfo.sh" /etc/profile.d/cheminfo.sh
    source /etc/profile.d/cheminfo.sh
then
    ok
else
    error
fi
