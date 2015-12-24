#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/scripts

source ../config.txt

source ./logging.sh
source ./general.sh
source ./iptables.sh
source ./nodejs.sh
source ./couchdb.sh
source ./httpd.sh