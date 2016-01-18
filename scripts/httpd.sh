message "Installing httpd"

if
    ! yum --assumeyes install httpd mod_ssl > /dev/null
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
       	systemctl start httpd.service > /dev/null
       	systemctl enable httpd.service > /dev/null
else
	service httpd start > /dev/null
	chkconfig httpd on > /dev/null
fi
