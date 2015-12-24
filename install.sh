#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/scripts

source ./logging.sh
source ./iptables.sh
# source ./general.sh
# source ./nodejs.sh
# source ./couchdb.sh

# source ./httpd.sh