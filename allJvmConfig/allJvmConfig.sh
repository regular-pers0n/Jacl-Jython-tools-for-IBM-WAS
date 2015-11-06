#!/bin/bash

# allJvmConfig.sh v1.0.23
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
# Usage:        ./allJvmConfig.sh

JACL="allJvmConfig.jacl"
OUTPUT_DIR=`echo "$(basename $0 .sh)_Output"`
WAS_HOME="/aplicaciones/websphere8/AppServer"
TC="$WAS_HOME/thinClient"
JVM_LIST=$1 #Optional

header () {
	LINE="----------------------------"
	printf "\n %s\n  Complete JVM configuration\n %s\n" $LINE $LINE
}

if [ ! -d $WAS_HOME ];then printf "\n - ERROR: WAS not found in \"%s\".\n" $WAS_HOME;exit 1;fi
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
