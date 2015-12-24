yum install --assumeyes iptables-services > /dev/null

message "Adding rules in iptables file"

if
    grep --silent CHEMINFO /etc/sysconfig/iptables
then
    ok
    info "The service was already configured and CHEMINFO is in the file"
else

    DATA=`cat ../configs/iptables | sed ':a;N;$!ba;s/\n/\\\\n/g'`

echo $DATA

    if
        sed -ibcp "/--dport 22/c$DATA" /etc/sysconfig/iptables
    then
        ok
        info "Rules where added in iptables"
        systemctl mask firewalld > /dev/null
        systemctl enable iptables > /dev/null
        systemctl stop firewalld.service > /dev/null
        systemctl start iptables.service > /dev/null
    else
        error
        info "Could not add rules in the iptables file"
    fi
fi