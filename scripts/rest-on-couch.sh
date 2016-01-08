
#########################################
## INSTALL AND CONFIGURE REST-ON-COUCH ##
#########################################

installRestOnCouch() {
  
  message "installing rest-on-couch"
  
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
  
    goto /usr/local/node
    su nodejs -c 'npm install -g rest-on-couch > /dev/null'
    su nodejs -c 'echo ${ROC_CONFIG} > /usr/local/node/.rest-on-couch-config'
    goback
    
    if
      crontab -l -u nodejs | grep 'rest-on-couch'
    then
      message "creating crontab entry for import"
      crontab -u nodejs > /tmp/crontab.nodejs
      echo '* * * * *  rest-on-couch import' >> /tmp/crontab.nodejs
      crontab -u nodejs /tmp/crontab.nodejs
      rm -f /tmp/crontab.nodejs
      ok
    fi
  fi
}

installRestOnCouch
