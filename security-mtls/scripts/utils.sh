#! /bin/bash

pause()
{
	newline
	read -p "Press Enter to continue" </dev/tty
	newline

}

newline()
{
  	echo ""
  	echo ""
}

showExec()
{
	PWD=`pwd`
	echo -e "${GREEN}[`basename ${PWD}`]\$ ${@/eval/}${WHITE}" ;
	echo -e "${MAGENTA}`$@`${WHITE}" ; 
}

showYaml()
{
	echo "# ###################################################"
	echo "# $1"
	echo "# ###################################################"
	yq $1
}


BLACK="\033[1;30m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"


