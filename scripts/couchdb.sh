#!/bin/bash



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

  CURRENT=`pwd`

  mkdir -p /usr/local/src/
  cd /usr/local/src/

  if [ -d "/usr/local/src/couchdb" ]; then
    error
    info "/usr/local/src/couchdb folder exists"
    info "Please delete this folder in order to recompile couchdb"
    cd $CURRENT
    return 1
  fi

  if
    git clone --quiet https://github.com/apache/couchdb.git couchdb > /dev/null
    cd couchdb
    git checkout --quiet 1.6.1 > /dev/null
  then
    ok
  else
    error
    cd $CURRENT
    return 1
  fi

  message "Compiling and installing couchDB"
  if
    ./bootstrap > /dev/null &&
    ./configure --with-erlang=/usr/lib64/erlang/usr/include --prefix=/ > /dev/null &&
    make > /dev/null &&
    make install > /dev/null
  then
    ok
  else
    error
    cd $CURRENT
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
  systemctl enable couchdb
  systemctl start couchdb


  if
    [ -n "$COUCHDB_ADMIN_PASSWORD" ]
  then
    message "Setting admin couchDB password"
    if
      curl -X PUT http://localhost:5984/_config/admins/username -d '"$COUCHDB_ADMIN_PASSWORD"'
    then
      ok
    else
      error
    fi
  else
    message "Undefined admin couchDB password"
    error
  fi

  cd $CURRENT
}

#########
## END ##
#########


installCouchDB
