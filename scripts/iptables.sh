yum install --assumeyes iptables-services > /dev/null

message "Adding rules in iptables file"

if
    grep --silent CHEMINFO /etc/sysconfig/iptables
then
    ok
    info "The service was already configured and CHEMINFO is in the file"
else
    if
        [ ! -z "$SSH_ACCESS" ]
    then
        DATA="";
        for IP in $SSH_ACCESS; do
            DATA=$DATA"-A INPUT -s $IP -p tcp -m tcp --dport 22 -j ACCEPT\\n"
        done
    else
        DATA="-A INPUT -p tcp --dport 22 -j ACCEPT\\n"
    fi
    IPTABLES=`cat ../configs/iptables | sed ':a;N;$!ba;s/\n/\\\\n/g'`
    DATA="$DATA\\n$IPTABLES\\n"


    if
        sed -i.bcp "/--dport 22/c$DATA" /etc/sysconfig/iptables
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
