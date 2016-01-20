#######################
## LOGGING FUNCTIONS ## 
#######################

COLUMNS=`stty size | cut -f2 -d" "`
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NORMAL="\e[0m"
OK="[${GREEN}OK${NORMAL}]"
ERROR="[${RED}ERROR${NORMAL}]"
WARNING="[${YELLOW}WARNING${NORMAL}]"
TEXT_WIDTH=`expr $COLUMNS - 12`
STR_FORMAT="%-${TEXT_WIDTH}.${TEXT_WIDTH}s"

message() {
  printf $STR_FORMAT "$1"
}

info() {
  printf "  $STR_FORMAT\n" "$1"
}

ok() {
  echo -e $OK
}

warning() {
  echo -e $WARNING
}

error() {
  echo -e $ERROR
}

printResult() {
	status=$?
        if
                [ $status -eq 0 ]
        then
                ok
        else
                error
        fi
	return $status
}

printLs() {
	status=$?
	if
		[ $status -ne 0 ] || [ "$DEBUG" -eq 1 ] && [ "$DEBUG" -ne -1 ]
	then
		ls -lR "$1"
	fi
	return $status
}

printCat() {
	status=$?
	if
		[ $status -ne 0 ] || [ "$DEBUG" -eq 1 ] && [ "$DEBUG" -ne -1 ]
	then
		cat "$1"
	fi
	return $status
}

printStatus() {
	status=$?
	if
		[ $status -ne 0 ] || [ "$DEBUG" -eq 1 ] && [ "$DEBUG" -ne -1 ]
	then
		if
			[ $REDHAT_RELEASE -eq 7 ]
		then
       	 		systemctl status $1
		else
			service $1 status
		fi
	fi
	return $status
}

CURRENT=''
goto() {
  CURRENT=`pwd`
  cd "$1"
}

goback() {
  cd "${CURRENT}"
  CURRENT=''
}

execnode() {
  su nodejs -l -c "$1"
}

copynode() {
  cp "$1" "$2"
  chown nodejs "$2"
}

copydirnode() {
  cp -r "$1" "$2"
  chown -R nodejs "$2"
}
