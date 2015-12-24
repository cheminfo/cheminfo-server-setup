
message "Installing epel-release, git and screen"

if
    yum --assumeyes install epel-release git screen >> /dev/null
then
    ok
else
    error
fi

message "Disabling IPv6"

if
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null &&
    sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null
then
    ok
else
    error
fi

