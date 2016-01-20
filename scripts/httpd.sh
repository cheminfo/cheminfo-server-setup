message "Installing httpd"

if
    ! yum --assumeyes install httpd mod_ssl > $LOG
then
    error
    return 1;
fi

ok

message "We install cheminfo.conf configuration file"

if
    [ -f "/etc/httpd/conf.d/cheminfo.conf" ]
then
    ok
    info "Configuration file was already present"
else
    cp ../configs/cheminfo.conf /etc/httpd/conf.d/cheminfo.conf
    ok
    info "Configuration file was copied"
fi

if
	[ $REDHAT_RELEASE -eq 7 ]
then
       	systemctl start httpd.service > $LOG
       	systemctl enable httpd.service > $LOG
else
	service httpd start > $LOG
	chkconfig httpd on > $LOG
fi
