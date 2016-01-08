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
