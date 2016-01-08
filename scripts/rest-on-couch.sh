
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
    execnode 'echo ${ROC_CONFIG} > /usr/local/node/.rest-on-couch-config'
    ok
  fi
  
  if
    [ ! -f "/usr/local/node/latest/bin/rest-on-couch" ]
  then
    message "installing rest-on-couch"
    goto /usr/local/node
    execnode 'npm install -g rest-on-couch > /dev/null'
    goback
    ok
  fi
    
  if
    ! (crontab -l -u nodejs 2>/dev/null | grep -q 'rest-on-couch')
  then
    message "creating crontab entry for import"
    crontab -l -u nodejs > /tmp/crontab.nodejs 2>/dev/null
    echo '* * * * *  rest-on-couch import' >> /tmp/crontab.nodejs
    crontab -u nodejs /tmp/crontab.nodejs
    rm -f /tmp/crontab.nodejs
    ok
  fi
  
  if
    [ ! -f "/usr/local/pm2/roc-server.json" ]
  then
    message "configuring server"
    copynode "${DIR}/configs/roc-server.json" /usr/local/pm2/roc-server.json
    execnode "pm2 start /usr/local/pm2/roc-server.json" >/dev/null
    execnode "pm2 dump" >/dev/null
    ok
  fi
}

installRestOnCouch
