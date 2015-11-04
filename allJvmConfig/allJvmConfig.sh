#!/bin/ksh

# allJvmConfig.sh v1.0.21
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
# Info:		This Tcl program creates a Replication Domain that the session
#		manager uses for replication of the dynamic cache service, and
#		the stateful session bean failover components.
#
# Usage:	./allJvmConfig.sh

HOSTNAME=`hostname`
UNAME=`uname`

case $UNAME in
	SunOS) AWK=`echo "nawk"` ;;
	AIX) AWK=`echo "awk"` ;;
	Linux) AWK=`echo "awk"` ;;
esac

JACL="allJvmConfig.jacl"

clear
printf "\n #######################\n"
printf "  CONFIGURACION DE JVMs "
printf "\n #######################\n\n"
printf " 1. IBM WebSphere Application Server 6.1\n"
printf " 2. IBM WebSphere Application Server 7.0\n"
printf " 3. IBM WebSphere Application Server 8.0\n"
printf " 4. IBM WebSphere Application Server 8.5\n"
printf "\n Selecciona la version de WAS para la que quieres sacar la informacion: "
read SEL

case $SEL in
	1) VERSION="6.1" ;;
	2) VERSION="7.0" ;;
	3) VERSION="8.0" ;;
	4) VERSION="8.5" ;;
	*) echo "";echo " ERROR: La opcion seleccionada no es valida.";echo"";exit ;;
esac

cabecera () {
	echo ""
	echo " ###############################################"
	echo "  Configuracion completa de las JVMs en WAS $VERSION"
	echo " ###############################################"
}

WAS_HOME="/opt/IBM/websphere/AppServer${VERSION}"
TC="$WAS_HOME/thinClient"
LISTA="listaJVMs_${VERSION}.txt"

if [ ! -d $WAS_HOME ];then echo "";echo " - ERROR: En esta maquina no hay WAS $VERSION";echo "";exit;fi
if [ ! -f $LISTA ];then echo "";echo " - ERROR: No existe el archivo \"$LISTA\".";echo "";exit;fi
if [ ! -d $VERSION ];then mkdir $VERSION;fi

clear
cabecera
if [ -f $TC/thinClient.sh ]
	then
		echo " [Usando ThinClient]"
		$TC/thinClient.sh -f $JACL $VERSION $LISTA | egrep -v 'Connected|mediante|argv variable|variable argv'
	else
		echo " [Usando wsadmin]"
		$WAS_HOME/bin/wsadmin.sh -f $JACL $VERSION $LISTA | egrep -v 'Connected|mediante|argv variable|variable argv'
fi
