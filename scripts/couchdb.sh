#!/bin/bash

COUCHDB_FOLDER="apache-couchdb-1.6.1"

########################
## INSTALLING COUCHDB ##
########################

installCouchDB() {

  message "Checking if couchDB is installed"
  if couchdb -V &> /dev/null; then
    if couchdb -V | grep -q "1\.6\.1"; then
      ok
      info "Already installed and version is ok"
    else
      error
      info "CouchDB version is not 1.6.1, please remove it"
    fi
    return
  else
    ok
    info "CouchDB not yet installed"
  fi


  message "Installing required package for couchDB compilation"
  if
    yum --assumeyes install autoconf autoconf-archive automake curl-devel erlang erlang-asn1 erlang-erts erlang-eunit erlang-os_mon erlang-xmerl gcc-c++ help2man js-devel libicu-devel libtool perl-Test-Harness > /dev/null
  then
    ok
  else
    error
  fi

  message "Cloning couchDB git repository"

  mkdir -p /usr/local/src/
  goto /usr/local/src/

  if [ -d "/usr/local/src/$COUCHDB_FOLDER" ]; then
    error
    info "/usr/local/src/$COUCHDB_FOLDER folder exists"
    info "Please delete this folder in order to recompile couchdb"
    goback
    return 1
  fi

  if
    curl -s  http://mirror.switch.ch/mirror/apache/dist/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz | tar -zx
  then
    ok
    cd $COUCHDB_FOLDER
  else
    error
    goback
    return 1
  fi

  message "Compiling and installing couchDB"
  if

    if [ $ARCH -eq 64 ]; then
      TAG="64"
    else
      TAG=""
    fi

    ./configure --with-erlang=/usr/lib$TAG/erlang/usr/include --prefix=/ > /dev/null &&
    make > /dev/null &&
    make install > /dev/null
  then
    ok
  else
    error
    goback
    return 1
  fi

  message "Checking if username couchdb exists"
  if getent passwd couchdb >/dev/null 2>&1; then
    ok
    info "Username couchdb exists already"
  else
    useradd --comment "CouchDB Administrator" --home-dir /var/lib/couchdb --user-group --system --shell /bin/bash couchdb
    ok
    info "User couchdb was created"
  fi

  chown -R couchdb:couchdb /etc/couchdb /var/lib/couchdb /var/log/couchdb /var/run/couchdb

  mv /etc/rc.d/couchdb /etc/init.d/couchdb
  chkconfig --add couchdb
	if
		[ $REDHAT_RELEASE -eq 7 ]
	then
		systemctl enable couchdb
		systemctl start couchdb
	else
		chkconfig couchdb on > /dev/null
		service couchdb start > /dev/null
	fi


  if
    [ -n "$COUCHDB_ADMIN_USERNAME" ] && [ -n "$COUCHDB_ADMIN_PASSWORD" ]
  then
    message "Setting up CouchDB administrator"
    if
      curl -X PUT http://localhost:5984/_config/admins/${COUCHDB_ADMIN_USERNAME} -d "\"${COUCHDB_ADMIN_PASSWORD}\""
    then
      ok
    else
      error
    fi
  else
    message "Undefined CouchDB administrator. Database will be in admin party mode."
    warning
  fi

  goback
}

#########
## END ##
#########


installCouchDB
