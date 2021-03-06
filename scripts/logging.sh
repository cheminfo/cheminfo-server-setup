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

confirm() {
    # call with a prompt string or use a default
    PROMPT="${1:-Continue? [y/N]} "
    read -r -p "$PROMPT" response
    case ${response:0:1} in
        [yY])
            true
            ;;
        "")
            true
            ;;
        *)
            false
            ;;
    esac
}

prompt() {
    # $1 = prompt message
    # $2 = default value
    PROMPT="${1:-Type someting}: "
    DEFAULT=$2
    if [[ ! -z $DEFAULT ]]; then
        PROMPT="$PROMPT [$DEFAULT] "
    fi

    while true; do
        read -r -p $PROMPT response
        if [[ -z $response ]]; then
            if [[ ! -z $DEFAULT ]]; then
                echo $DEFAULT
                return
            fi
        else
            echo $response
            return
        fi
    done
}
