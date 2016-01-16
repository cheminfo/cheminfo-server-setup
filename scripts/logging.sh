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
        if
                [ $? -eq 0 ]
        then
                ok
        else
                error
        fi
}

printLs() {
	if
		[ $? -ne 0 ] || [ $DEBUG -eq 1 ]
	then
		find "$1"
	fi
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
  su nodejs -c "$1"
}

copynode() {
  cp "$1" "$2"
  chown nodejs "$2"
}

copydirnode() {
  cp -r "$1" "$2"
  chown -R nodejs "$2"
}
