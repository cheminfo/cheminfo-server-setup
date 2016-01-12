
#########################################
## INSTALL AND CONFIGURE REST-ON-COUCH ##
#########################################

installRestOnCouch() {
  echo "configuring rest-on-couch"
  
  if 
    [ ! -d "${ROC_HOME_DIR}" ]
  then
    message "copy demo data"
    mkdir -p ${ROC_HOME_DIR}
    chown -R nodejs ${ROC_HOME_DIR}
    copydirnode "${DIR}/data" ${ROC_HOME_DIR}
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
    execnode 'git clone https://github.com/cheminfo/rest-on-couch.git > /dev/null'
    cd rest-on-couch
    execnode 'npm install --production > /dev/null'
    goback
    ok
  fi
    
#  if
#    ! (crontab -l -u nodejs 2>/dev/null | grep -q 'rest-on-couch')
#  then
#    message "creating crontab entry for import"
#    crontab -l -u nodejs > /tmp/crontab.nodejs 2>/dev/null
#    echo '* * * * *  /usr/local/node/latest/bin/rest-on-couch import --limit 100' >> /tmp/crontab.nodejs
#    crontab -u nodejs /tmp/crontab.nodejs
#    rm -f /tmp/crontab.nodejs
#    ok
#  fi
  
  if
    [ ! -f "/usr/local/pm2/roc-server.json" ]
  then
    message "configuring server"
    copynode "${DIR}/configs/roc-server.json" /usr/local/pm2/roc-server.json
    execnode "pm2 startOrRestart /usr/local/pm2/roc-server.json" >/dev/null
    execnode "pm2 dump" >/dev/null
    ok
  fi

  if
    [ ! -f "/usr/local/pm2/roc-import.json" ]
  then
    message "configuring import service"
    copynode "${DIR}/configs/roc-import.json" /usr/local/pm2/roc-import.json
    execnode "pm2 startOrRestart /usr/local/pm2/roc-import.json" >/dev/null
    execnode "pm2 dump" >/dev/null
    ok
  fi
}

installRestOnCouch
