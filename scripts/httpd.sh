message "Installing httpd"

if
    ! yum --assumeyes install httpd mod_ssl > /dev/null
then
    error
    return 1;
fi

ok

## Need to add the cheminfo configuration file


systemctl enable httpd
systemctl start httpd
