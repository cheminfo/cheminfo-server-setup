yum install --assumeyes iptables-services > /dev/null

message "Adding rules in iptables file"

if
    grep --silent CHEMINFO /etc/sysconfig/iptables
then
    ok
    info "The service was already configured and CHEMINFO is in the file"
else

read -d '' DATA <<EOF

##### CHEMINFO

-A INPUT -s 128.178.0.0/15 -p tcp -m tcp --dport ssh -j ACCEPT -m comment --comment "EPFL"
-A INPUT -s 84.72.124.142 -p tcp -m tcp --dport ssh -j ACCEPT -m comment --comment "Temp test"

-A INPUT -m recent --name Unwelcome --update --seconds 86400 -j DROP

-A INPUT -p tcp -m tcp --dport http -j ACCEPT
-A INPUT -p udp -m udp --dport http -j ACCEPT
-A INPUT -p tcp -m tcp --dport https -j ACCEPT
-A INPUT -p udp -m udp --dport https -j ACCEPT

# "Unwelcome" hostile traffic blocking rule.
# Traffic coming from sources previously identified as hostile
# is dropped during a certain period -- currently 86400 seconds
-A INPUT -j LOG --log-level 4 --log-prefix "IPT"
-A INPUT -m recent --name Unwelcome --set

#### END CHEMINFO

EOF

    DATA2=`echo "$DATA" | sed ':a;N;$!ba;s/\n/\\\\n/g'`
if
    sed -ibcp "/--dport 22/c$DATA2" /etc/sysconfig/iptables
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