
#########################################
## INSTALL AND CONFIGURE REST-ON-COUCH ##
#########################################

installRestOnCouch() {
  echo "configuring rest-on-couch"
  
  if 
    [ ! -d "${ROC_HOME_DIR}" ]
  then
    message "copy demo data"
    mkdir -p "${ROC_HOME_DIR}"
    cp -r ${DIR}/data/* "${ROC_HOME_DIR}"
    chown -R nodejs "${ROC_HOME_DIR}"
    ok
  fi

  if 
    [ ! -f "/usr/local/node/.rest-on-couch-config" ]
  then
    ## Build the config file
    message "building the config file"
    ROC_CONFIG="{\"homeDir\": \"${ROC_HOME_DIR}\""
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
    [ ! -d "/usr/local/pm2/rest-on-couch" ]
  then
    message "installing rest-on-couch"
    goto /usr/local/pm2
    execnode 'git clone https://github.com/cheminfo/rest-on-couch.git' > $LOG
    cd rest-on-couch
    execnode 'npm install --production' > $LOG
    goback
    ok
  fi
  
  if
    [ ! -f "/usr/local/pm2/roc-server.json" ]
  then
    message "configuring server"
    goto /usr/local/node
    copynode "${DIR}/configs/roc-server.json" /usr/local/pm2/roc-server.json
    execnode "pm2 startOrRestart /usr/local/pm2/roc-server.json" > $LOG
    execnode "pm2 dump" >$LOG
    goback
    ok
  fi

  if
    [ ! -f "/usr/local/pm2/roc-import.json" ]
  then
    message "configuring import service"
    goto /usr/local/node
    copynode "${DIR}/configs/roc-import.json" /usr/local/pm2/roc-import.json
    execnode "pm2 startOrRestart /usr/local/pm2/roc-import.json" > $LOG
    execnode "pm2 dump" >$LOG
    goback
    ok
  fi
}

installRestOnCouch
