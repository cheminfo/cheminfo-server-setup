
#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/scripts

source ../config.txt

source ./logging.sh

message "Checking if node is present in /usr/bin/node"
whereis node | grep -q "/usr/bin/node"
printResult


message "Checking if node is version 5.x.x"
node -v | grep -q "v5"
printResult

message "Checking if pm2 is running as user nodejs"
ps aux | grep -v "grep" | grep "PM2" | grep -q "nodejs"
printResult

message "Checking if roc-server is running on pm2"
su nodejs -c "pm2 status" | grep "roc-server" | grep -q "online"
printResult

message "Checking if roc-import is running on pm2"
su nodejs -c "pm2 status" | grep "roc-import" | grep -q "online"
printResult

message "Checking if couchDB is running as user couchdb"
ps aux | grep -v "grep" | grep -q "^couchdb"
printResult

message "Checking if apache (httpd) is running as user apache"
ps aux | grep -v "grep" | grep "^apache" | grep -q "httpd"
printResult

message "Checking if iptables is running"
systemctl status iptables | grep -q "Active: active"
printResult
