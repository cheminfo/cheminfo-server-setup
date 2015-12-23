yum install --assumeyes iptables-services

read -d '' DATA <<EOF

##### CHEMINFO

-A INPUT -s 128.178.0.0/15 -p tcp -m tcp --dport ssh -j ACCEPT -m comment --comment "EPFL" 
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
sed -ibcp "/--dport 22/c$DATA2" /etc/sysconfig/iptables

systemctl mask firewalld
systemctl enable iptables
systemctl stop firewalld.service
systemctl start iptables.service
