#!/bin/bash

# allJvmConfig.sh v1.0.25
# Copyleft - 2013  Javier Dominguez Gomez
# Written by Javier Dominguez Gomez <jdg@member.fsf.org>
# GnuPG Key: 6ECD1616
# Madrid, Spain
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Info:         This Tcl program creates a Replication Domain that the session
#               manager uses for replication of the dynamic cache service, and
#               the stateful session bean failover components.
#
# Usage:        ./allJvmConfig.sh -f [file] | -v | -h

VERSION="1.0.25"
DATE_VERSION="11/10/2015"
SELF_NAME=`echo "$(basename $0 .sh)"`
JACL="allJvmConfig.jacl"
OUTPUT_DIR="${SELF_NAME}_Output"
WAS_HOME="/aplicaciones/websphere8/AppServer"
TC="$WAS_HOME/thinClient"

header() {
	LINE="----------------------------"
	printf "\n %s\n  Complete JVM configuration\n %s\n" $LINE $LINE
}

usage() {
        printf " Usage:\t\t%s -f [file] | -v | -h\n" $0
}

help() {
	printf "\n HELP\n\n\t"
	usage
	printf "\n\t Example:\t%s -f jvmList.txt \n" $0
	printf "\n\t Description:\tThis  free  software  utility obtains  all  information  about  the JVM\n"
	printf "\t\t\tconfiguration in  IBM WebSphere  Application  Server.  You can see  the\n"
	printf "\t\t\toutput by  screen and  log file  also. If you prefer  you can specify a\n"
	printf "\t\t\tfile with a list of  specific JVMs, this requires to use the -f option.\n"
	printf "\t\t\tIf you do not specify the file, will get all the  information about all\n"
	printf "\t\t\tIBM WebSphere Application Server JVM instances in a cell.\n"
	printf "\n\t Options:\t-f [file]\tIts optional. If you  use this option  you must specify\n"
	printf "\t\t\t\t\tthe file that  contains a custom jvm list to obtain all\n"
	printf "\t\t\t\t\tconfiguration  information.  Comments  and blank  lines\n"
	printf "\t\t\t\t\twill be ignored.\n\n"
	printf "\t\t\t-v\t\tOutput version and date.\n\n"
	printf "\t\t\t-h\t\tThis help.\n\n"
	printf "\n\t GitHub:\thttps://github.com/ingenieriainversa/Jacl-Jython-tools-for-IBM-WAS\n\n"
	printf "\n\t License:\tThis program  is free software: you  can redistribute  it and/or modify\n"
	printf "\t\t\tit under the terms  of the GNU General  Public License as  published by\n"
	printf "\t\t\tthe Free Software Foundation,  either version 3 of the  License, or (at\n"
	printf "\t\t\tyour option) any later version.\n\n"
	printf "\t\t\tThis  program is  distributed in  the hope that it  will be useful, but\n"
	printf "\t\t\tWITHOUT   ANY   WARRANTY;  without   even  the   implied   warranty  of\n"
	printf "\t\t\tMERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See the GNU\n"
	printf "\t\t\tGeneral Public License for more details.\n\n"
	printf "\t\t\tYou should have received a copy of the GNU General Public License along\n"
	printf "\t\t\twith this program.  If not, see <http://www.gnu.org/licenses/>.\n\n"
	exit 0
}

version() {
	printf "%s v%s [%s]\n" $SELF_NAME $VERSION $DATE_VERSION
}

PROD=""
while getopts f:vh flag
do
	case $flag in
		f) JVM_LIST="$OPTARG" ;;
		v) version;exit 0 ;;
		h|*) help;exit 2 ;;
	esac
done
shift $(($OPTIND -1))

if [ ! -f $JVM_LIST ];then printf "\n ERROR: The file \"%s\" do not exist.\n\n" $JVM_LIST;exit 1;fi
if [ ! -d $WAS_HOME ];then printf "\n ERROR: WAS not found in \"%s\".\n\n" $WAS_HOME;exit 1;fi
if [ ! -d $OUTPUT_DIR ];then mkdir $OUTPUT_DIR;fi

clear
header
if [ -f $TC/thinClient.sh ]
	then
		printf " [Using ThinClient]\n"
		$TC/thinClient.sh -f $JACL $OUTPUT_DIR $JVM_LIST | egrep -v 'WASX7209I|WASX7303I'
	else
		printf " [Using wsadmin]\n"
		$WAS_HOME/bin/wsadmin.sh -f $JACL $OUTPUT_DIR $JVM_LIST | egrep -v 'WASX7209I|WASX7303I'
fi
