
#########################################
## INSTALL AND CONFIGURE REST-ON-COUCH ##
#########################################

installRestOnCouch() {
  
  echo "configuring rest-on-couch"
  
  if 
    [ ! -d "/usr/local/rest-on-couch" ]
  then
    mkdir -p /usr/local/rest-on-couch
    chown -r nodejs /usr/local/rest-on-couch
  fi

  if 
    [ ! -f "/usr/local/node/.rest-on-couch-config" ]
  then
    ## Build the config file
    message "building the config file"
    ROC_CONFIG="{\"homeDir\": \"/usr/local/rest-on-couch\""
    if
      [ -n "$COUCHDB_ADMIN_USERNAME" ] && [ -n "$COUCHDB_ADMIN_PASSWORD" ]
    then
      ROC_CONFIG=${ROC_CONFIG}",\"username\":\"${COUCHDB_ADMIN_USERNAME}\",\"password\":\"${COUCHDB_ADMIN_PASSWORD}\""
    fi
    ROC_CONFIG=${ROC_CONFIG}"}"
    export ROC_CONFIG
    su nodejs -c 'echo ${ROC_CONFIG} > /usr/local/node/.rest-on-couch-config'
    ok
  fi
  
  if
    [ ! -f "/usr/local/node/latest/bin/rest-on-couch" ]
  then
    message "installing rest-on-couch"
    goto /usr/local/node
    su nodejs -c 'npm install -g rest-on-couch > /dev/null'
    goback
    ok
  fi
    
  if
    ! crontab -l -u nodejs 2>/dev/null | grep 'rest-on-couch' 2&> /dev/null
  then
    message "creating crontab entry for import"
    crontab -l -u nodejs > /tmp/crontab.nodejs
    echo '* * * * *  rest-on-couch import' >> /tmp/crontab.nodejs
    crontab -u nodejs /tmp/crontab.nodejs
    rm -f /tmp/crontab.nodejs
    ok
  fi
}

installRestOnCouch
