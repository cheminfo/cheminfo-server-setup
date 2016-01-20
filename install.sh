#!/bin/bash



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/rest-on-couch.log"

echo "Log file: $LOG"
touch $LOG
chmod 777 $LOG

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8


cd $DIR/scripts

source ../config.txt

source ./logging.sh
source ./general.sh
source ./iptables.sh
source ./nodejs.sh
source ./couchdb.sh
source ./httpd.sh
source ./rest-on-couch.sh
