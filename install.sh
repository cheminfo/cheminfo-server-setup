#!/bin/bash



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG="/tmp/rest-on-couch.log"

echo "Log file: $LOG"
echo "You can following the installation using: tail -f $LOG"
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
confirm "install nodejs (y/n) ? " && source ./nodejs.sh
confirm "install couchdb (y/n) ? " && source ./couchdb.sh
confirm "install httpd (y/n) ? " && source ./httpd.sh
confirm "install rest-on-couch (y/n) ? " && source ./rest-on-couch.sh
