
#########################################
## INSTALL AND CONFIGURE REST-ON-COUCH ##
#########################################

installRestOnCouch() {
  if 
    [ ! -d "/usr/local/rest-on-couch" ]
  then
    mkdir -p /usr/local/rest-on-couch
    chown nodejs /usr/local/rest-on-couch
  fi

  if 
    [ ! -f "/usr/local/node/.rest-on-couch-config" ]
  then
    ## Build the config file
    ROC_CONFIG="{\"homeDir\": \"/usr/local/rest-on-couch\""
    if
      [ -n "$COUCHDB_ADMIN_USERNAME" ] && [ -n "$COUCHDB_ADMIN_PASSWORD" ]
    then
      ROC_CONFIG=${ROC_CONFIG}",\"username\":\"${COUCHDB_ADMIN_USERNAME}\",\"password\":\"${COUCHDB_ADMIN_PASSWORD}\""
    fi
    ROC_CONFIG=${ROC_CONFIG}"}"
    export ROC_CONFIG
  
    ## Commands that need to be run by the nodejs user
    su nodejs
    npm install -g rest-on-couch > /dev/null
    echo ${ROC_CONFIG} > /usr/local/node/.rest-on-couch-config
    # TODO clone demo repositories
    exit
    
    if
      crontab -l -u nodejs | grep 'rest-on-couch'
    then
      crontab -u nodejs > /tmp/crontab.nodejs
      echo '* * * * *  rest-on-couch import' >> /tmp/crontab.nodejs
      crontab -u nodejs /tmp/crontab.nodejs
      rm /tmp/crontab.nodejs
    fi
  fi
}

installRestOnCouch
